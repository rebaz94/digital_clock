import 'package:digital_clock/src/utility/utility.dart';
import 'package:digital_clock/src/widgets/active_tick.dart';
import 'package:digital_clock/src/clock_customizer/clock_model.dart';
import 'package:digital_clock/src/widgets/inactive_tick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This class shows Current time along with current second
class Clock extends StatefulWidget {
  final ClockModel model;

  Clock({Key key, this.model}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  ClockModel _model;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _controller.repeat();

    _model = widget.model;
    _model.addListener(_updateModel);
  }

  @override
  void dispose() {
    _model.removeListener(_updateModel);
    _controller.removeListener(_updateModel);
    _controller.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final theme = Theme.of(context);
        final isHidingTickCompletely =
            _model.hideSecondTick && _model.hideSecondBackground;
        _model.update(DateTime.now());
        return Stack(
          children: <Widget>[
            AnimatedOpacity(
              opacity: _model.hideSecondBackground ? 0 : 1,
              duration: const Duration(milliseconds: 1000),
              child: const InactiveTick(),
            ),
            AnimatedOpacity(
              opacity: _model.hideSecondTick ? 0 : 1,
              duration: const Duration(milliseconds: 1000),
              child: ActiveTick(
                second: _model.dateTime.second + 1,
                tickColor: theme.primaryColor,
                isHided: _model.hideSecondTick,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: Text(
                _model.hourTime,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: Utility.textSize48,
                  letterSpacing: 3,
                  fontFamily: 'Lato',
                ),
                semanticsLabel: 'Digital clock with'
                    ' time ${widget.model.currentTime}',
              ),
            ),
            ExcludeSemantics(
              child: AnimatedOpacity(
                opacity: isHidingTickCompletely ? 0 : 1,
                duration: const Duration(milliseconds: 400),
                child: Align(
                  alignment: const Alignment(0.49, -0.03),
                  child: Text(
                    _model.month,
                    style: TextStyle(
                      color: theme.primaryColorDark,
                      fontSize: Utility.textSize18,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              alignment: Alignment(0, isHidingTickCompletely ? 0.73 : 0.65),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: Text.rich(
                TextSpan(text: _model.weekTime, children: [
                  if (isHidingTickCompletely)
                    TextSpan(
                      text: '${_model.monthName}',
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
                semanticsLabel: '${_model.weekTimeLong}',
              ),
            ),
            AnimatedOpacity(
              opacity: _model.is24HourFormat ? 0 : 1,
              duration: const Duration(milliseconds: 1000),
              child: Align(
                alignment: const Alignment(-0.0, 0.05),
                child: Text(
                  _model.amPm,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: Utility.textSize11,
                    fontFamily: 'Lato',
                  ),
                  semanticsLabel: '',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
