import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_package/widget_package.dart';

void main() {
  testWidgets('BounceTap fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: BounceTap(onTap: () => taps++, child: const Text('hi')),
    ));
    await tester.tap(find.text('hi'));
    expect(taps, 1);
  });

  testWidgets('Backgrounds render their child', (tester) async {
    for (final bg in <Widget>[
      const AnimatedGradientBackground(child: Text('x')),
      const FloatingBubblesBackground(child: Text('x')),
      const WaveBackground(child: Text('x')),
    ]) {
      await tester.pumpWidget(MaterialApp(home: bg));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('x'), findsOneWidget);
    }
  });

  testWidgets('FadeSlideIn shows child after delay', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: FadeSlideIn(delay: Duration(milliseconds: 100), child: Text('y')),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('y'), findsOneWidget);
  });
}
