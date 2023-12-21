import 'dart:math' as math;

extension NumX<T extends num> on T {
  double get radians => (this * math.pi) / 180.0;
  double get stepsInAngle => (math.pi * 2) / this;
}
