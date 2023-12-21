import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_advance_util/extensions/num_extensions.dart';

/// A simple flower petals animation.
class PetalMenu extends StatefulWidget {
  final double? height, width;

  /// A list of [Petal]s. At least one petal.
  final List<Petal> petals;

  /// [FittedBox] behaviour of child widget in each petal.
  final BoxFit? fit;

  /// Starting option of petals.
  final int initialIndex;

  /// Hit behaviour of each petal.
  final HitTestBehavior? behavior;

  /// Duration of delay after user action, default 250ms
  final Duration delay;

  /// Duration of animation, default 250ms.
  final Duration duration;

  /// A simple flower petals animation.
  const PetalMenu(
      {super.key,
      required this.petals,
      this.fit,
      required this.initialIndex,
      this.behavior,
      this.delay = const Duration(milliseconds: 250),
      this.duration = const Duration(milliseconds: 250),
      this.height,
      this.width});

  @override
  State<PetalMenu> createState() => _PetalMenuState();
}

class _PetalMenuState extends State<PetalMenu> with TickerProviderStateMixin {
  bool isOpen = false;
  late Petal selectedColor;
  late final AnimationController _animationController;

  @override
  void initState() {
    assert(widget.petals.isNotEmpty, 'List must have at least one child');
    super.initState();

    selectedColor = widget.petals[widget.initialIndex];
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      upperBound: 1.1,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        const springDescription = SpringDescription(
          mass: 0.8,
          stiffness: 180.0,
          damping: 20.0,
        );
        final simulation = SpringSimulation(springDescription,
            _animationController.value, 0.05, _animationController.velocity);
        _animationController.animateWith(simulation);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openMenu() {
    _animationController.reset();

    const springDescription = SpringDescription(
      mass: 0.8,
      stiffness: 180.0,
      damping: 20.0,
    );
    final simulation = SpringSimulation(
        springDescription, 0, 1, _animationController.velocity);
    _animationController.animateWith(simulation);
    setState(() {
      isOpen = true;
    });
  }

  void _closeMenu(Petal color) {
    _animationController.reverse();
    setState(() {
      selectedColor = color;
    });
    Future.delayed(widget.delay, () {
      setState(() {
        _animationController.reset();
        isOpen = false;
      });
      if (color.onTap != null) color.onTap!();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _closeMenu(selectedColor),
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds: widget.duration.inMilliseconds ~/ 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        selectedColor.color.withOpacity(0.2),
                        selectedColor.color.withOpacity(0.5),
                        selectedColor.color
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: _animationController
                          .drive(Tween(
                              begin: (widget.width ?? size.width) * 0.4,
                              end: widget.width ?? (size.width * 0.9)))
                          .value,
                      height: widget.height ?? (size.width * 0.9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white70,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: isOpen ? 30 : 10,
                            offset: Offset(
                              0,
                              isOpen ? 10 : 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...widget.petals.asMap().entries.map((e) {
                      final angle = e.key * (360 / widget.petals.length);

                      return Visibility(
                        visible: isOpen,
                        child: GestureDetector(
                          onTap: () {
                            _closeMenu(e.value);
                          },
                          behavior: widget.behavior,
                          child: Transform.rotate(
                            angle: _animationController
                                .drive(Tween(begin: 0.0, end: angle.radians))
                                .value,
                            child: Transform.translate(
                              offset: Offset(
                                0.0,
                                _animationController
                                    .drive(Tween(
                                        begin: 0.0,
                                        end: -(widget.width ?? size.width) *
                                            0.2))
                                    .value,
                              ),
                              child: Container(
                                height: _animationController
                                    .drive(Tween(
                                        begin:
                                            (widget.width ?? size.width) * 0.25,
                                        end: (widget.width ?? size.width) *
                                            0.40))
                                    .value,
                                width: (widget.width ?? size.width) * 0.25,
                                //Increasing the margin solve the hit issue
                                margin: const EdgeInsets.all(100),
                                decoration: BoxDecoration(
                                  color: e.value.color,
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.petals[e.key].color,
                                      widget.petals[e.key].color,
                                      widget.petals[e.key].color
                                          .withOpacity(0.7)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _animationController
                                          .drive(ColorTween(
                                              begin: Colors.transparent,
                                              end: Colors.black
                                                  .withOpacity(0.4)))
                                          .value!,
                                      blurRadius: 5,
                                      offset: const Offset(0, 12),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      (((widget.width ?? size.width) * 0.40) /
                                              2) -
                                          10),
                                ),
                                child: Visibility(
                                  visible: isOpen,
                                  child: FittedBox(
                                      fit: widget.fit ?? BoxFit.contain,
                                      child: e.value.child),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    if (!isOpen)
                      GestureDetector(
                        onTap: _openMenu,
                        behavior: widget.behavior,
                        child: Container(
                          width: (widget.width ?? size.width) * 0.3,
                          height: (widget.width ?? size.width) * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedColor.color,
                          ),
                          child: FittedBox(
                              fit: widget.fit ?? BoxFit.contain,
                              child: selectedColor.child),
                        ),
                      )
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class Petal {
  final VoidCallback? onTap;
  final MaterialColor color;
  final Widget? child;

  Petal(this.color, {this.child, this.onTap});
}
