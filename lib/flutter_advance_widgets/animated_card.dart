import 'package:flutter/material.dart';

class AnimatedCard extends StatefulWidget {
  /// A simple animated card that changes color upon user interaction. Useful for displaying information a creative way but could be made to execute a function by setting the [action] parameter.
  const AnimatedCard({
    Key? key,
    required this.activeColor,
    this.inactiveColor,
    required this.icon,
    required this.detail,
    required this.actionText,
    this.action,
    required this.height,
    required this.width,
    this.shadowColor,
    this.shadowPosition = const Offset(0, 3),
    this.spacing,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    this.iconSize,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.black,
    this.borderRadius = 10,
    this.actionFontWeight = FontWeight.w500,
    this.detailFontWeight = FontWeight.w600,
    this.actionAlignment = Alignment.bottomRight,
  }) : super(key: key);

  final double height;
  final double width;
  final double? spacing;
  final double borderRadius;
  final EdgeInsets padding;
  final Size? iconSize;

  final Color activeColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color? inactiveColor;
  final Color? shadowColor;

  final Offset shadowPosition;

  final Widget icon;

  final FontWeight actionFontWeight;
  final FontWeight detailFontWeight;

  final Alignment actionAlignment;

  /// Text to display in the middle of the card.
  final String detail;

  /// Text to display at the bottom of the card.
  final String actionText;

  /// action to perform upon user interaction with the [actionText].
  final VoidCallback? action;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween(begin: 1.0, end: 11.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.isCompleted) {
          _controller.reverse();
          setState(() {
            _isActive = false;
          });
        } else {
          _controller.forward();
          setState(() {
            _isActive = true;
          });
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor ?? Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: widget.shadowPosition,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Padding(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        height: widget.iconSize?.height ?? widget.height * 0.1,
                        width: widget.iconSize?.width ?? widget.width * 0.05,
                        decoration: BoxDecoration(
                          color: widget.activeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: widget.iconSize?.height ?? widget.height * 0.1,
                      width: widget.iconSize?.width ?? widget.width * 0.05,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (widget.inactiveColor ?? widget.activeColor)
                              .withOpacity(_opacityAnimation.value)),
                      child: widget.icon,
                    ),
                  ],
                ),
                widget.spacing != null
                    ? SizedBox(height: widget.spacing)
                    : const Spacer(),
                Text(
                  widget.detail,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _isActive
                          ? widget.activeTextColor
                          : widget.inactiveTextColor),
                ),
                widget.spacing != null
                    ? SizedBox(height: widget.spacing)
                    : const Spacer(),
                Align(
                  alignment: widget.actionAlignment,
                  child: GestureDetector(
                    onTap: widget.action,
                    child: Text(
                      widget.actionText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: widget.actionFontWeight,
                          color: _isActive
                              ? widget.activeTextColor
                              : widget.inactiveTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
