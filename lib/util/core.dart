import 'dart:math' as math;

import 'package:flutter/material.dart';

Offset getCurrentCirclePosition(Size frameSize, double dimension, int i) {
  final x = ((frameSize.width / 1.2) / dimension) * (i % dimension) +
      ((frameSize.width) / dimension) * 0.7;
  final y = ((frameSize.height / 2) / dimension) * (i ~/ dimension) +
      ((frameSize.height) / dimension) * 0.9;
  return Offset(x, y);
}

Offset toPolar(Offset center, double radians, double radius) {
  return center +
      Offset(radius * math.cos(radians), radius * math.sin(radians));
}
