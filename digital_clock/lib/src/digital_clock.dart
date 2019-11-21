// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:digital_clock/src/utility/utility.dart';
import 'package:digital_clock/src/widgets/clock.dart';
import 'package:digital_clock/src/clock_customizer/clock_model.dart';
import 'package:digital_clock/src/widgets/header_icon.dart';
import 'package:digital_clock/src/widgets/header_status.dart';
import 'package:digital_clock/src/widgets/location_name.dart';
import 'package:flutter/material.dart';

/// This is main widget which is used as a container to wrap all widget and animate between widget whenever anything change from the model.
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  static const Duration updateHeaderDuration = const Duration(seconds: 33);
  static const Duration animDuration400 = const Duration(milliseconds: 400);
  static const Duration animDuration300 = const Duration(milliseconds: 300);

  DateTime _now = DateTime.now();
  Timer _timer;
  bool _isShowingWeather = true;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    if (!mounted) return;
    setState(() {
      if (widget.model.isCharging) {
        _updateHeader();
      } else {
        _timer?.cancel();
        _timer = null;
        _isShowingWeather = true;
      }
    });
  }

  void _updateHeader() {
    if (!mounted) return;
    setState(() {
      _timer?.cancel();
      _isShowingWeather = !_isShowingWeather;
      _timer = Timer(
        updateHeaderDuration - Duration(milliseconds: _now.millisecond),
        _updateHeader,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final showCharging = widget.model.isCharging && !_isShowingWeather;
    final isHidingTickCompletely =
        widget.model.hideSecondTick && widget.model.hideSecondBackground;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  Colors.blueGrey[800].withOpacity(0.2),
                  Colors.blueGrey.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Color(0xffC9D6FF),
                  Color(0xffeef2f3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
      ),
      child: Stack(
        children: [
          Clock(
            model: widget.model,
          ),
          AnimatedAlign(
            alignment: Alignment(
              showCharging ? 0 : -0.17,
              isHidingTickCompletely ? -0.83 : -0.75,
            ),
            curve: Curves.easeInOut,
            duration: animDuration400,
            child: HeaderIcon(
              showCharging: showCharging,
              iconName: widget.model.weatherString,
            ),
          ),
          AnimatedAlign(
            alignment: Alignment(
              0.0,
              isHidingTickCompletely ? -0.53 : -0.45,
            ),
            curve: Curves.easeInOut,
            duration: animDuration400,
            child: HeaderStatus(
              showCharging: showCharging,
              chargeTime: widget.model.chargeTime,
              weatherState: widget.model.weatherString,
            ),
          ),
          AnimatedAlign(
            alignment: Alignment(
              0,
              isHidingTickCompletely ? 0.49 : 0.41,
            ),
            curve: Curves.easeInOut,
            duration: animDuration400,
            child: LocationName(
              name: widget.model.location,
            ),
          ),
          AnimatedOpacity(
            duration: animDuration300,
            opacity: showCharging ? 0 : 1,
            child: AnimatedAlign(
              curve: Curves.easeInOut,
              duration: animDuration400,
              alignment: Alignment(
                !showCharging ? 0.18 : 0.17,
                isHidingTickCompletely ? -0.78 : -0.71,
              ),
              child: Text.rich(
                TextSpan(
                  text: widget.model.temperatureWithoutUnit,
                  children: [
                    TextSpan(
                      text: widget.model.unitString[0],
                      style: TextStyle(
                        fontSize: Utility.textSize16,
                        color: theme.primaryColorLight,
                      ),
                    ),
                    TextSpan(
                      text: widget.model.unitString[1],
                      style: TextStyle(
                        fontSize: Utility.textSize11,
                        color: theme.primaryColorLight,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: theme.primaryColorLight,
                  fontSize: Utility.textSize18,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
