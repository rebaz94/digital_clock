// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// This is the model that contains the customization options for the clock.
///
/// It is a [ChangeNotifier], so use [ChangeNotifier.addListener] to listen to
/// changes to the model. Be sure to call [ChangeNotifier.removeListener] in
/// your `dispose` method.
///
/// Contestants: Do not edit this.
class ClockModel extends ChangeNotifier {
  ThemeMode get themeMode => _themeMode;
  ThemeMode _themeMode = ThemeMode.light;

  set themeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  get is24HourFormat => _is24HourFormat;
  bool _is24HourFormat = true;

  set is24HourFormat(bool is24HourFormat) {
    if (_is24HourFormat != is24HourFormat) {
      _is24HourFormat = is24HourFormat;
      notifyListeners();
    }
  }

  /// Current location String, for example 'Mountain View, CA'.
  get location => _location;
  String _location = 'Mountain View, CA';

  set location(String location) {
    if (location != _location) {
      _location = location;
      notifyListeners();
    }
  }

  /// Current temperature string, for example '22°C'.
  get temperature => _convertFromCelsius(_temperature);

  // Stored in degrees celsius, and converted based on the current unit setting
  num _temperature = 22.0;

  set temperature(num temperature) {
    temperature = _convertToCelsius(temperature);
    if (temperature != _temperature) {
      _temperature = temperature;
      _low = _temperature - 3.0;
      _high = _temperature + 4.0;
      notifyListeners();
    }
  }

  /// Daily high temperature, for example '26'.
  get high => _convertFromCelsius(_high);

  // Stored in degrees celsius, and converted based on the current unit setting
  num _high = 26.0;

  set high(num high) {
    high = _convertToCelsius(high);
    if (high != _high) {
      _high = high;
      notifyListeners();
    }
  }

  /// Daily low temperature, for example '19'.
  get low => _convertFromCelsius(_low);
  num _low = 19.0;

  set low(num low) {
    low = _convertToCelsius(low);
    if (low != _low) {
      _low = low;
      notifyListeners();
    }
  }

  /// Weather condition text for the current weather, for example  'cloudy'.
  WeatherCondition get weatherCondition => _weatherCondition;
  WeatherCondition _weatherCondition = WeatherCondition.cloudy;

  set weatherCondition(WeatherCondition weatherCondition) {
    if (weatherCondition != _weatherCondition) {
      _weatherCondition = weatherCondition;
      notifyListeners();
    }
  }

  /// [WeatherCondition] value without the enum type.
  String get weatherString => enumToString(weatherCondition);

  /// Temperature unit, for example 'celsius'.
  TemperatureUnit get unit => _unit;
  TemperatureUnit _unit = TemperatureUnit.celsius;

  set unit(TemperatureUnit unit) {
    if (unit != _unit) {
      _unit = unit;
      notifyListeners();
    }
  }

  /// Temperature with unit of measurement.
  String get temperatureString {
    return '${temperature.toStringAsFixed(1)}$unitString';
  }

  String get temperatureWithoutUnit {
    return '${temperature.toStringAsFixed(1)}';
  }

  /// Temperature high with unit of measurement.
  String get highString {
    return '${high.toStringAsFixed(1)}$unitString';
  }

  /// Temperature low with unit of measurement.
  String get lowString {
    return '${low.toStringAsFixed(1)}$unitString';
  }

  /// Temperature unit of measurement with degrees.
  String get unitString {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.celsius:
      default:
        return '°C';
    }
  }

  num _convertFromCelsius(num degreesCelsius) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return 32.0 + degreesCelsius * 9.0 / 5.0;
      case TemperatureUnit.celsius:
      default:
        return degreesCelsius;
        break;
    }
  }

  num _convertToCelsius(num degrees) {
    switch (unit) {
      case TemperatureUnit.fahrenheit:
        return (degrees - 32.0) * 5.0 / 9.0;
      case TemperatureUnit.celsius:
      default:
        return degrees;
        break;
    }
  }

  /// extra functions to [ClockModel]
  get isCharging => _isCharging;
  bool _isCharging = false;

  set isCharging(bool isCharging) {
    if (_isCharging != isCharging) {
      _isCharging = isCharging;
      notifyListeners();
    }
  }

  get hideSecondBackground => _hideSecondBackground;
  bool _hideSecondBackground = false;

  set hideSecondBackground(bool hideSecondBackground) {
    if (_hideSecondBackground != hideSecondBackground) {
      _hideSecondBackground = hideSecondBackground;
      notifyListeners();
    }
  }

  get hideSecondTick => _hideSecondTick;
  bool _hideSecondTick = false;

  set hideSecondTick(bool hideSecondTick) {
    if (_hideSecondTick != hideSecondTick) {
      _hideSecondTick = hideSecondTick;
      notifyListeners();
    }
  }

  get chargeTime => _chargeTime;
  String _chargeTime = '18 Min';

  set chargeTime(String chargeTime) {
    if (_chargeTime != chargeTime) {
      _chargeTime = chargeTime;
      notifyListeners();
    }
  }

  DateTime _time = DateTime.now();
  static final DateFormat currentTimeFormat = DateFormat.Hms();
  static final DateFormat twentyFourHourFormat = DateFormat.Hm();
  static final DateFormat twelveHourFormat = DateFormat('hh:mm');
  static final DateFormat weekTimeFormat = DateFormat('EEE dd');
  static final DateFormat weekTimeLongFormat = DateFormat('EEEE MMMM dd, yyyy');
  static final DateFormat amOrPmFormat = DateFormat('aa');
  static final DateFormat monthFormat = DateFormat('MM');
  static final DateFormat monthNameFormat = DateFormat.MMM();

  DateTime get dateTime => _time;

  void update(DateTime time) {
    _time = time;
  }

  String get hourTime {
    if (is24HourFormat) return twentyFourHourFormat.format(_time);
    return twelveHourFormat.format(_time);
  }

  String get weekTime {
    return weekTimeFormat.format(_time).toUpperCase();
  }

  String get weekTimeLong {
    return weekTimeLongFormat.format(_time).toUpperCase();
  }

  String get amPm {
    return amOrPmFormat.format(_time);
  }

  String get month {
    return monthFormat.format(_time);
  }

  String get monthName {
    return monthNameFormat.format(_time);
  }

  String get currentTime {
    return currentTimeFormat.format(DateTime.now());
  }
}

/// Weather condition in English.
enum WeatherCondition {
  cloudy,
  foggy,
  rainy,
  snowy,
  sunny,
  thunderstorm,
  windy,
}

/// Temperature unit of measurement.
enum TemperatureUnit {
  celsius,
  fahrenheit,
}

/// Removes the enum type and returns the value as a String.
String enumToString(Object e) => e.toString().split('.').last;
