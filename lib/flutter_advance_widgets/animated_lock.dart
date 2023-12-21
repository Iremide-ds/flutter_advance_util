import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_advance_util/extensions/path_extension.dart';

class AnimatedLock extends StatefulWidget {
  final AnimationController controller;
  final bool showSwitch;
  final Color lockedColor;
  final Color unlockedColor;
  final Color overlayColor;
  final Size? size;
  final double lockRadius;
  const AnimatedLock(
      {Key? key,
      required this.controller,
      required this.showSwitch,
      required this.lockedColor,
      required this.unlockedColor,
      required this.overlayColor,
      this.size,
      this.lockRadius = 70})
      : super(key: key);

  @override
  State<AnimatedLock> createState() => _AnimatedLockState();
}

class _AnimatedLockState extends State<AnimatedLock>
    with SingleTickerProviderStateMixin {
  late bool isLocked;
  late Animation<double> _arcAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.reverse();
    _arcAnimation =
        Tween(begin: -180 * math.pi / 180, end: -90 * math.pi / 180).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.elasticInOut),
    );
    isLocked = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: LockPainter(
                  arcAnimation: _arcAnimation,
                  isLocked: isLocked,
                  lockedColor: widget.lockedColor,
                  overlayColor: widget.overlayColor,
                  unlockedColor: widget.unlockedColor,
                  lockRadius: widget.lockRadius),
            ),
          ),
          Visibility(
            visible: widget.showSwitch,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLocked ? "Locked" : "Unlock",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Switch.adaptive(
                    value: isLocked,
                    onChanged: (value) {
                      setState(() {
                        isLocked = !isLocked;
                        if (isLocked) {
                          widget.controller.reverse();
                        } else {
                          widget.controller.forward();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LockPainter extends CustomPainter {
  final Color lockedColor;
  final Color unlockedColor;
  final Color overlayColor;
  final double lockRadius;
  LockPainter({
    required this.lockRadius,
    required this.lockedColor,
    required this.unlockedColor,
    required this.overlayColor,
    required this.arcAnimation,
    this.isLocked = false,
  });

  final Animation<double> arcAnimation;

  final bool isLocked;
  @override
  void paint(Canvas canvas, Size size) {
    // main rect paint
    final paint = Paint()
      ..color = isLocked ? lockedColor : unlockedColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    //overlay paint
    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    //arc paint
    final arcPaint = Paint()
      ..color = isLocked ? lockedColor : unlockedColor
      ..strokeWidth = 20
      ..shader
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    //draw arc of a circle
    canvas.drawArc(
      Rect.fromCircle(
          center: size.center(const Offset(0, -125)), radius: lockRadius),
      (isLocked ? 0 : 30) * math.pi / 180,
      arcAnimation.value,
      false,
      arcPaint,
    );

    //use to prevent arc rounded edge from showing
    final overlayPath = Path().drawCustomRRect(size);

    //main RRect
    final path = Path().drawCustomRRect(size);

    //draw both overlay and  RRect on canvas

    canvas.drawPath(overlayPath, overlayPaint);
    if (!isLocked) {
      canvas.drawShadow(path, Colors.green.withOpacity(0.5), 3, true);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
