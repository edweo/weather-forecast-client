import 'package:assignment3/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

double kelvinToC(num K) {
  return K - 273.15;
}

Image weatherIconBasedOnHour(Weather weather, int hh) {
  Image weatherImg;
  if (hh >= 21 || hh <= 5) {
    weatherImg = Image.asset(weatherNightIcons[weather]!);
  } else {
    weatherImg = Image.asset(weatherDayIcons[weather]!);
  }
  return weatherImg;
}

AssetImage weatherBackgroundBasedOnHour(Weather weather, int hh) {
  AssetImage weatherBackground;
  if (hh >= 21 || hh <= 5) {
    weatherBackground = AssetImage(weatherNightBackgrounds[weather]!);
  } else {
    weatherBackground = AssetImage(weatherDayBackgrounds[weather]!);
  }
  return weatherBackground;
}

String timeStringFormatted(int hh, int mm) {
  String timeFormatted;
  if (hh <= 9) {
    if (mm <= 9) {
      timeFormatted = '0$hh:0$mm';
    } else {
      timeFormatted = '0$hh:$mm';
    }
  } else {
    if (mm <= 9) {
      timeFormatted = '$hh:0$mm';
    } else {
      timeFormatted = '$hh:$mm';
    }
  }
  return timeFormatted;
}

// This method requests location permissions and determines the
// current position of the device by returning the
// Latitude and Longitude.
//
// Code taken from: https://pub.dev/packages/geolocator
Future<bool> determinePosition() async {
  Position pos = await Geolocator.getCurrentPosition();
  MyApp.positionDetermined = true;
  MyApp.latitue = pos.latitude;
  MyApp.longitude = pos.longitude;

  return pos == null ? false : true;
}

// Code taken from: https://pub.dev/packages/geolocator
Future<bool> promptLocationAccess() async {
  // Test if location services are enabled.
  var serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return false;
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return false;
  }

  return true;
}

Weather? determineWeather(String desc) {
  switch(desc) {
    case 'clear sky': return Weather.clear_sky;
    case 'few clouds': return Weather.few_clouds;
    case 'scattered clouds': return Weather.scattered_clouds;
    case 'broken clouds': return Weather.broken_clouds;
    case 'shower rain': return Weather.shower_rain;
    case 'rain': return Weather.rain;
    case 'thunderstorm': return Weather.thunderstorm;
    case 'show': return Weather.snow;
    case 'mist': return Weather.mist;

    case 'Clouds': return Weather.few_clouds;
    case 'Rain': return Weather.rain;
    case 'Drizzle': return Weather.rain;
    case 'Thunderstorm': return Weather.thunderstorm;
    case 'Snow': return Weather.snow;
    case 'Snow': return Weather.snow;
  }

  return Weather.few_clouds; // Default return if non defined values exist
}

enum Weather {
  clear_sky,
  few_clouds,
  scattered_clouds,
  broken_clouds,
  shower_rain,
  rain,
  thunderstorm,
  snow,
  mist
}

const String weatherPath = 'assets/icons/weather';
const weatherDayIcons = {
  Weather.clear_sky: '$weatherPath/day/day_clear_sky.png',
  Weather.few_clouds: '$weatherPath/day/day_few_clouds.png',
  Weather.scattered_clouds: '$weatherPath/day/day_scattered_clouds.png',
  Weather.broken_clouds: '$weatherPath/day/day_broken_clouds.png',
  Weather.shower_rain: '$weatherPath/day/day_shower_rain.png',
  Weather.rain: '$weatherPath/day/day_rain.png',
  Weather.thunderstorm: '$weatherPath/day/day_thunderstorm.png',
  Weather.snow: '$weatherPath/day/day_snow.png',
  Weather.mist: '$weatherPath/day/day_mist.png',
};

const weatherNightIcons = {
  Weather.clear_sky: '$weatherPath/night/night_clear_sky.png',
  Weather.few_clouds: '$weatherPath/night/night_few_clouds.png',
  Weather.scattered_clouds: '$weatherPath/night/night_scattered_clouds.png',
  Weather.broken_clouds: '$weatherPath/night/night_broken_clouds.png',
  Weather.shower_rain: '$weatherPath/night/night_shower_rain.png',
  Weather.rain: '$weatherPath/night/night_rain.png',
  Weather.thunderstorm: '$weatherPath/night/night_thunderstorm.png',
  Weather.snow: '$weatherPath/night/night_snow.png',
  Weather.mist: '$weatherPath/night/night_mist.png',
};

const String backgroundPath = 'assets/backgrounds';
const weatherDayBackgrounds = {
  Weather.clear_sky: '$backgroundPath/day/day_clear_sky_background.jpg',
  Weather.few_clouds: '$backgroundPath/day/day_cloudy_background.jpg',
  Weather.scattered_clouds: '$backgroundPath/day/day_cloudy_background.jpg',
  Weather.broken_clouds: '$backgroundPath/day/day_cloudy_background.jpg',
  Weather.shower_rain: '$backgroundPath/day/day_rain_background.jpg',
  Weather.rain: '$backgroundPath/day/day_rain_background.jpg',
  Weather.thunderstorm: '$backgroundPath/day/day_thunderstorm_background.jpg',
  Weather.snow: '$backgroundPath/day/day_snow_background.jpg',
  Weather.mist: '$backgroundPath/day/day_snow_background.jpg',
};

const weatherNightBackgrounds = {
  Weather.clear_sky: '$backgroundPath/night/night_clear_sky_background.jpg',
  Weather.few_clouds: '$backgroundPath/night/night_cloudy_background.jpg',
  Weather.scattered_clouds: '$backgroundPath/night/night_cloudy_background.jpg',
  Weather.broken_clouds: '$backgroundPath/night/night_cloudy_background.jpg',
  Weather.shower_rain: '$backgroundPath/night/night_rain_background.jpg',
  Weather.rain: '$backgroundPath/night/night_rain_background.jpg',
  Weather.thunderstorm: '$backgroundPath/night/night_thunderstorm_background.jpg',
  Weather.snow: '$backgroundPath/night/night_snow_background.jpg',
  Weather.mist: '$backgroundPath/night/night_snow_background.jpg',
};

const weekdays = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};

const months = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};

