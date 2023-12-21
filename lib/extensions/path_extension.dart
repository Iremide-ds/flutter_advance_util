import 'dart:ui';

extension CustomRectX on Path {
  Path drawCustomRRect(Size size) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: size.center(Offset.zero),
          width: size.width / 2,
          height: size.height / 4,
        ),
        const Radius.circular(20),
      ),
    );
    return path;
  }
}
