import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_advance_util/extensions/num_extensions.dart';

class RainbowSticksPage extends StatelessWidget {
  final AnimationController animationController;
  final Size size;

  /// Draws a circle of rainbow colored sticks around a circle in the center of the size provided.
  const RainbowSticksPage(
      {super.key, required this.animationController, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _CiclePainter(animationController: animationController),
        size: size);
  }
}

class _CiclePainter extends CustomPainter {
  _CiclePainter({
    required AnimationController animationController,
  }) : _animationController = animationController;
  final AnimationController _animationController;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white60
      ..strokeWidth = 1;

    double innerCircleRadius = 30;
    double outerCircleRaius = 170;
    const circleThreshold = 20;
    final center = size.center(Offset.zero);

    for (var i = 1; i <= circleThreshold; i++) {
      final innerCirclePoint =
          toPolar(center, i, circleThreshold, innerCircleRadius);
      final outerCirclePoint =
          toPolar(center, i, circleThreshold, outerCircleRaius);

      final xCenter = (innerCirclePoint.dx + outerCirclePoint.dx) / 2;
      final yCenter = (innerCirclePoint.dy + outerCirclePoint.dy) / 2;

      double startValue = (i / circleThreshold) * 0.5;
      double endValue = math.min(startValue + 0.1, 1.0);

      final animation = Tween(begin: 0.0, end: 180.radians).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            startValue,
            endValue,
          ),
        ),
      );

      canvas
        ..save()
        ..translate(xCenter, yCenter)
        ..rotate(animation.value)
        ..translate(-xCenter, -yCenter);

      canvas.drawLine(innerCirclePoint, outerCirclePoint, linePaint);

      _drawCircle(canvas, innerCirclePoint, _innerCircleColor(i));

      _drawCircle(canvas, outerCirclePoint, _outerCircleColor(i));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CiclePainter oldDelegate) => true;

  Color _innerCircleColor(int index) {
    if (index > 0 && index <= 5) {
      return Colors.blue;
    } else if (index > 5 && index <= 10) {
      return Colors.pink;
    } else if (index > 10 && index <= 15) {
      return Colors.cyan;
    } else {
      return Colors.indigo;
    }
  }

  Color _outerCircleColor(int index) {
    if (index > 0 && index <= 5) {
      return Colors.yellowAccent;
    } else if (index > 5 && index <= 10) {
      return Colors.lightGreenAccent;
    } else if (index > 10 && index <= 15) {
      return Colors.redAccent;
    } else {
      return Colors.orangeAccent;
    }
  }

  void _drawCircle(Canvas canvas, Offset offset, Color color) {
    final paint = Paint()..color = color;
    canvas.drawCircle(offset, 7, paint);
  }
}

Offset toPolar(Offset center, int index, int total, double radius) {
  final theta = index * total.stepsInAngle;
  final dx = radius * math.cos(theta);
  final dy = radius * math.sin(theta);
  return Offset(dx, dy) + center;
}
