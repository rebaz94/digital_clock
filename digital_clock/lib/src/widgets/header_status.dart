import 'package:digital_clock/src/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Provide text status for weather or charging and animate between them when changes.
class HeaderStatus extends StatelessWidget {
  final bool showCharging;
  final String chargeTime;
  final String weatherState;
  final String temperature;

  const HeaderStatus({
    Key key,
    @required this.showCharging,
    @required this.weatherState,
    @required this.temperature,
    this.chargeTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state =
        showCharging ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: showCharging
            ? 'Charging time is $chargeTime'
            : 'Weather condition is $weatherState'
                'which is $temperature',
      ),
      child: ExcludeSemantics(
        child: AnimatedCrossFade(
          firstCurve: Curves.easeIn,
          secondCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 700),
          crossFadeState: state,
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
        ),
      ),
    );
  }
}
