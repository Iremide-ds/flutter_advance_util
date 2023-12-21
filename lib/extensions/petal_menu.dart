import 'package:flutter/material.dart';
import 'package:flutter_advance_util/flutter_advance_util.dart';

extension PetalMenuHelper on List<Petal> {
  PetalMenu buildPetalMenu(int initialIndex,
          {BoxFit? fit,
          HitTestBehavior? behavior,
          Duration? delay,
          Duration? duration}) =>
      PetalMenu(petals: this, initialIndex: initialIndex);
}
