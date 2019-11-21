import 'dart:math';

import 'package:flutter/material.dart';

/// This class is used to show current second and it will be updated every second
class ActiveTick extends StatelessWidget {
  const ActiveTick({
    Key key,
    @required this.date,
    @required this.tickColor,
    @required this.isHided,
  }) : super(key: key);

  /// Date used to provide current second
  final DateTime date;

  /// Color of tick
  final Color tickColor;

  /// This is provided to optimize build method when tick is hided. there is no need to call drawing
  final bool isHided;

  @override
  Widget build(BuildContext context) {
    if (isHided) return const SizedBox();
    return SizedBox.expand(
      child: CustomPaint(
        painter: _TickPaint(
          currentSecond: date.second + 1,
          tickColor: tickColor,
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

  _TickPaint({this.currentSecond, this.tickColor});

  /// This is used to provide paint object to second from 0 to current second minus one. [the grater part]
  Paint tickPaint;

  /// This is head of tick which is red in both cases[Dark] or [Light] theme
  Paint topTickPaint;

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = size.shortestSide / BASE_SIZE;

    tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 3.0 * scaleFactor;
    topTickPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = tickPaint.strokeWidth + 3;
    _paintTickMarks(canvas, size, scaleFactor);
  }

  void _paintTickMarks(Canvas canvas, Size size, double scaleFactor) {
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

      // Get the angle from 12 O'Clock to this tick (radians)
      angleFrom12 = i / 60.0 * 2.0 * pi;

      // Get the angle from 3 O'Clock to this tick
      // Note: 3 O'Clock corresponds with zero angle in unit circle
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
