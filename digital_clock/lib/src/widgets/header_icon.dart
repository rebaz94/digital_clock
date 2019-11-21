import 'package:digital_clock/src/utility/utility.dart';
import 'package:flutter/material.dart';

/// This class used to provide weather icon or charging icon and animate between them when changes
class HeaderIcon extends StatelessWidget {
  final bool showCharging;
  final String iconName;

  const HeaderIcon({
    Key key,
    this.showCharging,
    @required this.iconName,
  })  : assert(iconName != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final animTime = showCharging ? 300 : 450;
    final theme = Theme.of(context);
    return AnimatedCrossFade(
      duration: Duration(milliseconds: animTime),
      crossFadeState: (showCharging ?? false)
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Transform(
        alignment: Alignment.center,
        transform: Matrix4.skew(0.2, -0.1),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            theme.primaryColor,
            BlendMode.srcIn,
          ),
          child: Text(
            '⚡',
            style: TextStyle(
              fontSize: Utility.textSize18,
            ),
          ),
        ),
      ),
      secondChild: Image.asset(
        'assets/$iconName.png',
        height: Utility.weatherIcon,
        width: Utility.weatherIcon,
        color: theme.primaryColorLight,
      ),
    );
  }
}
