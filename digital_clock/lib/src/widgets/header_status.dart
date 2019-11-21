import 'package:digital_clock/src/utility/utility.dart';
import 'package:flutter/material.dart';

/// Provide text status for weather or charging and animate between them when changes.
class HeaderStatus extends StatelessWidget {
  final bool showCharging;
  final String chargeTime;
  final String weatherState;

  const HeaderStatus({
    Key key,
    @required this.showCharging,
    @required this.weatherState,
    this.chargeTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedCrossFade(
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeIn,
      duration: const Duration(milliseconds: 700),
      crossFadeState:
          showCharging ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Text(
        chargeTime ?? '',
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: Utility.textSize24,
          fontFamily: 'Lato',
        ),
      ),
      secondChild: Text(
        weatherState,
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: Utility.textSize24,
          fontFamily: 'Lato',
        ),
      ),
      layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild,
          Key bottomChildKey) {
        return Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              key: bottomChildKey,
              top: 0,
              child: bottomChild,
            ),
            Positioned(
              key: topChildKey,
              child: topChild,
            )
          ],
        );
      },
    );
  }
}
