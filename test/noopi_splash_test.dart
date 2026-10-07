import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noopi_app/noopi_splash.dart';

void main() {
  for (final size in [
    const Size(390, 844),
    const Size(320, 568),
    const Size(844, 390),
  ]) {
    testWidgets('centered 3D app logo fits $size and settles once', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var completed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NoopiSplash(onComplete: () => completed++)),
        ),
      );
      final finder = find.byKey(const ValueKey('noopi-app-logo'));
      final rect = tester.getRect(finder);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(size.width));
      expect(rect.bottom, lessThanOrEqualTo(size.height));
      expect(rect.center, Offset(size.width / 2, size.height / 2));
      expect(find.byType(Image), findsNothing);
      expect(find.byType(Text), findsNothing);
      await tester.pump(const Duration(milliseconds: 1200));
      expect(completed, 0);
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pump(const Duration(milliseconds: 16));
      expect(completed, 1);
      await tester.pump(const Duration(seconds: 5));
      expect(completed, 1);
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.getRect(finder), rect);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('reduced motion shows the finished logo immediately', (
    tester,
  ) async {
    var completed = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: NoopiSplash(onComplete: () => completed++),
        ),
      ),
    );
    expect(completed, 1);
    expect(tester.binding.transientCallbackCount, 0);
    expect(find.byKey(const ValueKey('noopi-app-logo')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
