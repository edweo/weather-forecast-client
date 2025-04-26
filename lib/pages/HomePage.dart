import 'package:assignment3/widgets/current_weather.dart';
import 'package:flutter/material.dart';
import 'package:assignment3/utils/utils.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  final _currentWeatherKey = GlobalKey<CurrentWeatherState>();
  late final CurrentWeather _currentWeather;
  AssetImage? _background;

  HomePageState() {
    _currentWeather = CurrentWeather(
      key: _currentWeatherKey,
      onRefreshParent: _changeWeatherBackground,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
      _background != null
      // With Weather Background Image
      ? Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          image: DecorationImage(
            image: _background!,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _currentWeather,
          ],
        ),
      )

      // Without Weather Background Image
      : Container(
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _currentWeather,
          ],
        ),
      );
  }

  void _changeWeatherBackground() {
    DateTime time = DateTime.now();
    int hh = time.hour;

    setState(() {
      _background = weatherBackgroundBasedOnHour(
          (_currentWeatherKey.currentState?.weather)!, hh);
    });
  }
}

