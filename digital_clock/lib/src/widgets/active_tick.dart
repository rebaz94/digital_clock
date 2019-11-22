import 'dart:math';

import 'package:flutter/material.dart';

/// This class is used to show current second and it will be updated every second
class ActiveTick extends StatelessWidget {
  const ActiveTick({
    Key key,
    @required this.second,
    @required this.tickColor,
  }) : super(key: key);

  /// Date used to provide current second
  final int second;

  /// Color of tick
  final Color tickColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRect(
        child: CustomPaint(
          painter: _TickPaint(
            currentSecond: second,
            tickColor: tickColor,
          ),
        ),
      ),
    );
  }
}

class _TickPaint extends CustomPainter {
  /// This is base size for all app drawing, based on this app can calculate scale factor for drawing object
  static const double BASE_SIZE = 320.0;

  /// This is current second of tick that will be rendered
  final int currentSecond;

  /// Color of tick
  final Color tickColor;

  const _TickPaint({
    this.currentSecond,
    this.tickColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = size.shortestSide / BASE_SIZE;
    _paintTickMarks(canvas, size, scaleFactor);
  }

  void _paintTickMarks(Canvas canvas, Size size, double scaleFactor) {
    /// This is used to provide paint object to second from 0 to current second minus one. [the grater part]
    Paint tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 3.0 * scaleFactor;

    /// This is head of tick which is red in both cases[Dark] or [Light] theme
    Paint topTickPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = tickPaint.strokeWidth + 3;

    double r = size.shortestSide / 2;
    double tick = 5 * scaleFactor;
    double longTick = 2.0 * tick;
    double p = longTick + 4 * scaleFactor;

    double len = longTick;

    double angleFrom12;
    double angleFrom3;
    for (int b = 1; b <= currentSecond - 1; b++) {
      int start = b;
      int i = start < 30 ? 30 : 90;
      i -= start;

      angleFrom12 = i / 60.0 * 2.0 * pi;
      angleFrom3 = pi / 2 - angleFrom12;

      canvas.drawLine(
        size.center(
          Offset(
            cos(angleFrom3) * (r + len - p),
            sin(angleFrom3) * (r + len - p),
          ),
        ),
        size.center(
          Offset(
            cos(angleFrom3) * (r - p),
            sin(angleFrom3) * (r - p),
          ),
        ),
        tickPaint,
      );
    }

    /// drawing header of tick
    int start = currentSecond;
    int i = start < 30 ? 30 : 90;
    i -= start;
    angleFrom12 = i / 60.0 * 2.0 * pi;
    angleFrom3 = pi / 2 - angleFrom12;
    canvas.drawLine(
      size.center(
        Offset(
          cos(angleFrom3) * (r + len - p),
          sin(angleFrom3) * (r + len - p),
        ),
      ),
      size.center(
        Offset(
          cos(angleFrom3) * (r - p),
          sin(angleFrom3) * (r - p),
        ),
      ),
      topTickPaint,
    );
  }

  @override
  bool shouldRepaint(_TickPaint oldDelegate) {
    return oldDelegate != this ||
        oldDelegate.currentSecond != oldDelegate.currentSecond ||
        oldDelegate.tickColor != tickColor;
  }
}
