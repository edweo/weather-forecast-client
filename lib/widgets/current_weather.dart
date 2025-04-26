import 'dart:convert';

import 'package:assignment3/main.dart';
import 'package:assignment3/widgets/box_button.dart';
import 'package:assignment3/widgets/loading_screen.dart';
import 'package:assignment3/widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:assignment3/utils/utils.dart';
import 'package:http/http.dart' as http;


class CurrentWeather extends StatefulWidget {

  late final Function? _onRefreshParent;

  CurrentWeather({super.key, Function? onRefreshParent}) {
    _onRefreshParent = onRefreshParent;
  }

  @override
  State<StatefulWidget> createState() => CurrentWeatherState();
}

class CurrentWeatherState extends State<CurrentWeather> {

  var _currentWeatherJSON;

  Image? _icon;
  String _city = '';
  String _country = '';
  String _weekday = '';
  String _date = '';
  String _currentTime = '';
  Weather? weather;
  String _weatherDescription = '';
  int _temperature = 0;

  bool _dataLoaded = false;
  bool _loading = false;
  String _loadingText = '';

  bool _error = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _loading
        ? LoadingScreen(loadingText: _loadingText)
        : !_dataLoaded
        ? BoxButton(btnOnPress: _fetchCurrentWeather, buttonText: "Current Weather", errorMsg: _errorText,)
        : Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                  children: [
                    if (_icon != null) _icon!,
                    const SizedBox(height: 5,),
                    _weatherText(_weatherDescription),
                    _temperatureText(_temperature),
                    _countryText(_city, _country),
                    const SizedBox(height: 5,),
                    _whiteText(_date),
                    _whiteText(_weekday),
                    _whiteText(_currentTime),
                  ],
              ),
            ),
            RefreshButton(onPress: _fetchCurrentWeather),
          ],
        ),
      ],
    );
  }

  Widget _weatherText(String text) {
    return Text(text.toUpperCase(),
      style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _countryText(String city, String country) {
    return Text('$city, $country',
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _temperatureText(int temperature) {
    return Text('$temperature°C',
      style: TextStyle(
        color:
        _temperature >= 30
            ? Colors.red
            : _temperature >= 20
            ? Colors.orange
            : _temperature > 10
            ? Colors.white
            : const Color(0xFF0B29BD),
        fontSize: 80,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _whiteText(String text) {
    return Text(text,
      style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold),
    );
  }

  void _showError(String err) {
    setState(() {
      _errorText = err;
      _error = true;
      _loading = false;
    });
  }

  void _hideError() {
    if (_error) {
      setState(() {
        _error = false;
        _errorText = null;
      });
    }
  }

  void _showLoading(String text) {
    setState(() {
      _loadingText = text;
      _loading = true;
    });
  }

  void _stopLoading() {
    if (_loading) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchCurrentWeather() async {

    // Get Current Position
    bool determinedPosition = false;
    if (!MyApp.positionDetermined) {
      bool locationEnabled = await promptLocationAccess();
      if (locationEnabled) {
        _showLoading("Getting Current Location");
        determinedPosition = await determinePosition();
      } else {
        _stopLoading();
        _showError("Location Access Denied");
      }
    } else {
      determinedPosition = true;
    }

    // Get Current Weather
    if (determinedPosition) {
      _showLoading("Refreshing Weather Data");

      final url = 'https://api.openweathermap.org/data/2.5/weather?lat=${MyApp.latitue}&lon=${MyApp.longitude}&appid=${MyApp.api}';

      try {
        var res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

        setState(() {
          _currentWeatherJSON = json.decode(res.body);
        });
        _updateWeather(_currentWeatherJSON);
        _notifyParentWeatherChange();
        _stopLoading();
        _hideError();
      } catch (e) {
        _stopLoading();
        _showError("Error Reaching Server");
      }
    } else {
      _showError("Location Access Denied");
    }
  }

  void _updateWeather(jsonData) {
    var timeEpoch = jsonData['dt'];
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeEpoch*1000);

    var desc = jsonData['weather'][0]['description'];
    Weather? newWeather = determineWeather(desc);

    int hh = dateTime.hour;
    int mm = dateTime.minute;

    setState(() {
      _weekday = weekdays[dateTime.weekday]!;
      _date = '${months[dateTime.month]}, ${dateTime.day}, ${dateTime.year}';
      _city = jsonData['name'];
      _country = jsonData['sys']['country'];
      _weatherDescription = desc;
      weather = newWeather;
      _temperature = kelvinToC(jsonData['main']['temp']).round();
      _currentTime = timeStringFormatted(hh, mm);
      _icon = weatherIconBasedOnHour(newWeather!, hh);

      if (!_dataLoaded) _dataLoaded = true;

    });
  }

  void _notifyParentWeatherChange() {
    if (widget._onRefreshParent != null) {
      widget._onRefreshParent!();
    }
  }
}