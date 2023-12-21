import 'package:flutter/material.dart';
import 'package:flutter_advance_util/extensions/num_extensions.dart';

import '../util/core.dart';

class AnimatedProgressBar extends StatefulWidget {
  /// A list of at least 2 [Color]s
  final List<Color> colors;
  final Size size;

  const AnimatedProgressBar(
      {Key? key, required this.colors, required this.size})
      : super(key: key);

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    assert(widget.colors.length > 1);
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
    _rotationAnimation = Tween(begin: 0.radians, end: 180.radians).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _radiusAnimation = Tween(begin: 20.0, end: 40.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _borderAnimation = Tween(begin: 5.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.rotate(
        angle: _rotationAnimation.value,
        child: ScaleTransition(
          scale: Tween(begin: 0.7, end: 1.0).animate(_controller),
          child: CustomPaint(
              painter: ProgressBarPainter(
                  rotationAnimation: _rotationAnimation,
                  radiusAnimation: _radiusAnimation,
                  borderAnimation: _borderAnimation,
                  colors: widget.colors),
              size: widget.size),
        ),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  ProgressBarPainter(
      {required this.colors,
      required this.rotationAnimation,
      required this.radiusAnimation,
      required this.borderAnimation});
  final Animation<double> rotationAnimation;
  final Animation<double> radiusAnimation;
  final Animation<double> borderAnimation;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    int temp = 0;
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderAnimation.value;

      canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCircle(
              center: toPolar(
                size.center(Offset.zero),
                temp.radians,
                100,
              ),
              radius: radiusAnimation.value,
            ),
            const Radius.circular(20),
          ),
          paint);
      temp = i + 40;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
