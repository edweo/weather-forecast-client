import 'package:assignment3/widgets/forecast_weather.dart';
import 'package:flutter/material.dart';

class ForecastPage extends StatefulWidget {

  const ForecastPage({super.key});

  @override
  State<StatefulWidget> createState() => ForecastPageState();
}

class ForecastPageState extends State<ForecastPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ForecastWeather(),
          SingleChildScrollView(
            child: ForecastWeather(),
          )
        ],
      ),
    );
  }
}

