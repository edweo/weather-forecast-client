import 'dart:convert';

import 'package:assignment3/main.dart';
import 'package:assignment3/utils/utils.dart';
import 'package:assignment3/widgets/box_button.dart';
import 'package:assignment3/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForecastWeather extends StatefulWidget {
  const ForecastWeather({super.key});

  @override
  State<StatefulWidget> createState() => _ForecastWeatherState();
}

class _ForecastWeatherState extends State<ForecastWeather> with AutomaticKeepAliveClientMixin {

  int _currentCardIndex = 0;
  List<Widget> _forecastCards = [];

  bool _error = false;
  String? _errorText;

  var _forecastWeatherJSON;
  var _forecastDayData;

  bool _dataLoaded = false;
  bool _loading = false;
  String _loadingText = '';
  
  late BoxButton boxBtn;

  @override
  bool get wantKeepAlive => true;

  _ForecastWeatherState() {
    boxBtn = BoxButton(btnOnPress: _fetchForecast, buttonText: 'Weather Forecast',);
  }

  @override
  Widget build(BuildContext context) {
    return
      _loading
      ? LoadingScreen(loadingText: _loadingText)
        : _dataLoaded
        ? Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width*0.9,
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                children: [
                  IndexedStack(
                    index: _currentCardIndex,
                    children: _forecastCards,
                  ),
                  forecastCardNavigationBar(
                      _forecastDayData[_currentCardIndex][0]['dt_txt'].split(' ')[0],
                      _currentCardIndex,
                      _forecastDayData.length
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: _fetchForecast,
                  icon: const Icon(Icons.refresh, size: 35,),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        )
    :  BoxButton(btnOnPress: _fetchForecast,
        buttonText: 'Weather Forecast', errorMsg: _errorText,);
  }

  void nextCard() {
    setState(() {
      _currentCardIndex++;
    });
  }

  void previousCard() {
    setState(() {
      _currentCardIndex--;
    });
  }

  Widget forecastCardNavigationBar(String dateForecastCard, int currentIndex, int cardsAmount) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Previous Card Button (LEFT)
          currentIndex == 0
              ? const IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios), splashColor: Colors.transparent,)
              : IconButton(onPressed: previousCard, icon: const Icon(Icons.arrow_back_ios, color: Colors.black,), splashColor: Colors.transparent,),

          Text(
            dateForecastCard,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // Next Card Button (RIGHT)
          currentIndex == cardsAmount-1
              ? const IconButton(onPressed: null, icon: Icon(Icons.arrow_forward_ios), splashColor: Colors.transparent,)
              : IconButton(onPressed: nextCard, icon: const Icon(Icons.arrow_forward_ios, color: Colors.black,), splashColor: Colors.transparent,),
        ],
      ),
    );
  }

  Widget singleDayForecastCard(singleDayForecasts) {
    String city = _forecastWeatherJSON['city']['name'];
    String country = _forecastWeatherJSON['city']['country'];

    int forecastsCount = singleDayForecasts.length;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$city, $country',
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10,),
          Column(
            children: [
              Wrap(
                runSpacing: 3,
                children: [
                  if (forecastsCount < 8) for (var i = 0; i < (8-forecastsCount); i++) emptyForecastRow(),
                  for (var row in singleDayForecasts) dayForecastRow(row),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget emptyForecastRow() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.timer_off_outlined),
          const SizedBox(width: 5,),
          Text('Time Passed',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget dayForecastRow(dayForecast) {
    var timeEpoch = dayForecast['dt'];
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeEpoch*1000);
    int forecastTime = dateTime.hour;

    var weatherDesc = dayForecast['weather'][0]['main'];
    Weather weather = determineWeather(weatherDesc)!;

    Image icon;
    if (forecastTime >= 21 || forecastTime <= 5) {
      icon = Image.asset(weatherNightIcons[weather]!);
    } else {
      icon = Image.asset(weatherDayIcons[weather]!);
    }

    // Add 0 before 0-9 HH and MM
    String forecastTimeFormatted;
    if (forecastTime <= 9) {
      forecastTimeFormatted = '0${forecastTime}:00';
    } else {
      forecastTimeFormatted = '${forecastTime}:00';
    }

    AssetImage weatherBackground;
    if (forecastTime >= 21 || forecastTime <= 5) {
      weatherBackground = AssetImage(weatherNightBackgrounds[weather]!);
    } else {
      weatherBackground = AssetImage(weatherDayBackgrounds[weather]!);
    }

    int temperature = kelvinToC(dayForecast['main']['temp']).round();

    return Container(
      height: 40,
      padding: const EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: weatherBackground,
            fit: BoxFit.cover,
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: icon,
                ),
                // const SizedBox(width: 10,),
              ],
            ),
          ),
          Expanded(
            child: Text(weatherDesc,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),)
          ,
          Expanded(
            child: Container(
              child: Text('$temperature°C',
                style: TextStyle(
                  color:
                  temperature >= 30
                      ? Colors.red
                      : temperature >= 20
                      ? Colors.orange
                      : temperature > 10
                      ? Colors.white
                      : const Color(0xFF0B29BD),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(forecastTimeFormatted,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchForecast() async {

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

    // Get Weather Forecast
    if (determinedPosition) {
      _showLoading("Refreshing Weather Forecast");

      final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=${MyApp.latitue}&lon=${MyApp.longitude}&appid=${MyApp.api}';

      try {
        var res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        var data = json.decode(res.body);

        setState(() {
          _forecastWeatherJSON = data;
        });

        _updateWeather(data);
        _stopLoading();
        _hideError();
      } catch (e) {
        print(e);
        _stopLoading();
        _showError("Error Reaching Server");
      }
    } else {
      _showError("Location Access Denied");
    }
  }

  void _updateWeather(jsonData) {

    var gottenDays = jsonData['list'];

    // Sort By Current day and divide forecasts between correct dates in the current timezone
    int prevTime = 0;
    bool nextDay = false;
    var forecastDays = []; // 2D array for each Day with it's Forecasts
    var dayForecast = [];
    for (var i = 0; i < gottenDays.length; i++) {


      var day = gottenDays[i];

      // Local Time
      var timeEpoch = day['dt'];
      var dateTime = DateTime.fromMillisecondsSinceEpoch(timeEpoch*1000);
      int forecastTime = dateTime.hour;

      // NEXT DAY
      int nextDayIndex;
      if (i+1 != gottenDays.length) {
        nextDayIndex = i+1;
      } else {
        nextDayIndex = gottenDays.length-1;
      }

      var nextDay = gottenDays[nextDayIndex];

      var timeEpochNextDay = nextDay['dt'];
      var dateTimeNextDay = DateTime.fromMillisecondsSinceEpoch(timeEpochNextDay*1000);
      int forecastTimeNextDay = dateTimeNextDay.hour;

      // Add day
      dayForecast.add(day);

      // Determine when NExt day Forecasts
      // if (forecastTime >= 23) {
      // if (forecastTime == 21) {

      // // TODO pakeisti i 0
      // if (forecastTime == 0) {


      if (forecastTime > forecastTimeNextDay) {
        forecastDays.add(dayForecast);
        dayForecast = [];
      }

    }
    List<Widget> cards = [];
    for (var day in forecastDays) {
      cards.add(singleDayForecastCard(day));
    }

    setState(() {
      _forecastDayData = forecastDays;
      _forecastCards = cards;

      if (!_dataLoaded) {
        _dataLoaded = true;
      }
    });
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
}