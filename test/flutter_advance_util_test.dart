import 'package:flutter/material.dart';
import 'package:flutter_advance_util/flutter_advance_util.dart';
import 'package:flutter_advance_util/flutter_advance_widgets/petal_menu.dart';
import 'package:flutter_test/flutter_test.dart';

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}

void main() {
  testWidgets('Petal menu animation', (WidgetTester tester) async {
    await tester.pumpWidget(_Wrapper(
      child: PetalMenu(petals: [
        Petal(Colors.blue, child: const Placeholder()),
        Petal(Colors.amber, child: const Placeholder()),
        Petal(Colors.purple, child: const Placeholder()),
        Petal(Colors.red, child: const Placeholder()),
        Petal(Colors.yellow, child: const Placeholder()),
        Petal(Colors.indigo, child: const Placeholder())
      ], initialIndex: 0),
    ));

    // Wait for the animation to complete.
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(find.byWidget(const SizedBox()), findsWidgets);
  });
}
