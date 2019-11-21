import 'dart:math';

import 'package:flutter/material.dart';

/// This is background tick behind [ActiveTick] which has some implementation but this one never changes.
class InactiveTick extends StatelessWidget {

  const InactiveTick({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _TickPaint(
          tickColor: Theme.of(context).indicatorColor
        ),
      ),
    );
  }
}

class _TickPaint extends CustomPainter {

  static const double BASE_SIZE = 320.0;

  final Color tickColor;

  const _TickPaint({this.tickColor});

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = size.shortestSide / BASE_SIZE;
    _paintTickMarks(canvas, size, scaleFactor);
  }

  void _paintTickMarks(Canvas canvas, Size size, double scaleFactor) {
    double r = size.shortestSide / 2;
    double tick = 5 * scaleFactor,
        longTick = 2.0 * tick;
    double p = longTick + 4 * scaleFactor;
    Paint tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 3.0 * scaleFactor;

    double len = longTick;
    for (int i = 1; i <= 60; i++) {
      double angleFrom12 = i / 60.0 * 2.0 * pi;

      double angleFrom3 = pi / 2.0 - angleFrom12;

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
  }

  @override
  bool shouldRepaint(_TickPaint oldDelegate) {
    return oldDelegate != this ||  oldDelegate.tickColor != tickColor;
  }
}
