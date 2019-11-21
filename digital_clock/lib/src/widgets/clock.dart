import 'dart:async';

import 'package:digital_clock/src/utility/utility.dart';
import 'package:digital_clock/src/widgets/active_tick.dart';
import 'package:digital_clock/src/clock_customizer/clock_model.dart';
import 'package:digital_clock/src/widgets/inactive_tick.dart';
import 'package:flutter/material.dart';

/// This class shows Current time along with current second
/// this class optimized so that whenever [InactiveTick] and [ActiveTick] is hided,
/// it just update one minute per time. otherwise it will be updated every second, and anything change from [ClockModel] will be updated directly.
class Clock extends StatefulWidget {
  final ClockModel model;

  Clock({Key key, this.model}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _now = DateTime.now();
  Timer _timer;

  ClockModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    model.addListener(_updateModel);

    model.update(DateTime.now());
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    _updateTime();
  }

  void _updateTime() {
    if (!mounted) return;
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      if (model.hideSecondTick) {
        _timer = Timer(
          Duration(seconds: 60) -
              (Duration(milliseconds: _now.millisecond) +
                  Duration(seconds: _now.second)),
          _updateTime,
        );
      } else {
        _timer = Timer(
          Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
          _updateTime,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHidingTickCompletely =
        model.hideSecondTick && model.hideSecondBackground;
    final theme = Theme.of(context);
    model.update(DateTime.now());

    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          opacity: model.hideSecondBackground ? 0 : 1,
          duration: const Duration(milliseconds: 1000),
          child: const InactiveTick(),
        ),
        AnimatedOpacity(
          opacity: model.hideSecondTick ? 0 : 1,
          duration: const Duration(milliseconds: 1000),
          child: ActiveTick(
            date: model.dateTime,
            tickColor: theme.primaryColor,
            isHided: model.hideSecondTick,
          ),
        ),
        Align(
          alignment: Alignment(0, 0),
          child: Text(
            model.hourTime,
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: Utility.textSize48,
              letterSpacing: 3,
              fontFamily: 'Lato',
            ),
          ),
        ),
        AnimatedAlign(
          alignment: Alignment(0, isHidingTickCompletely ? 0.73 : 0.65),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Text.rich(
            TextSpan(text: model.weekTime, children: [
              if (isHidingTickCompletely)
                TextSpan(
                  text: '${model.monthName}',
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: Utility.textSize11,
                    fontFamily: 'Lato',
                  ),
                )
            ]),
            style: TextStyle(
              color: theme.accentColor,
              fontSize: Utility.textSize24,
              fontFamily: 'Lato',
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: model.is24HourFormat ? 0 : 1,
          duration: const Duration(milliseconds: 1000),
          child: Align(
            alignment: const Alignment(-0.0, 0.05),
            child: Text(
              model.amPm,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: Utility.textSize11,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: isHidingTickCompletely ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          child: Align(
            alignment: const Alignment(0.49, -0.03),
            child: Text(
              model.month,
              style: TextStyle(
                color: theme.primaryColorDark,
                fontSize: Utility.textSize18,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
