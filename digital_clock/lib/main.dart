// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:digital_clock/src/clock_customizer/clock_customizer.dart';
import 'package:digital_clock/src/clock_customizer/clock_model.dart';
import 'package:digital_clock/src/digital_clock.dart';
import 'package:digital_clock/src/utility/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  /// ensure app is only showing in landscape mode
  /*WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);*/

  /// we just created new flutter project so,
  /// the [MyClockCustomizer] is same as [ClockCustomizer] from flutter_clock_helper
  /// but we added some function and new options to the drawer so we copied and put on my own class
  runApp(
    MyClockCustomizer(
      (ClockModel model) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Utility.init(MediaQuery.of(context).size, orientation);
            return DigitalClock(model);
          },
        );
      },
      lightTheme: Utility.lightTheme,
      darkTheme: Utility.darkTheme,
    ),
  );
}