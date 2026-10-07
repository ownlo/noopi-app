import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noopi_app/noopi_splash.dart';

Widget splash({bool reduced = true}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(
      disableAnimations: reduced,
      textScaler: const TextScaler.linear(1.3),
    ),
    child: const Scaffold(body: NoopiSplash()),
  ),
);

void main() {
  for (final size in [
    const Size(390, 844),
    const Size(320, 568),
    const Size(844, 390),
  ]) {
    testWidgets('shared play scene fits $size with no text or logo', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(splash());
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const ValueKey('play-scene')), findsOneWidget);
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('play scene animates', (tester) async {
    await tester.pumpWidget(splash(reduced: false));
    final noopi = find.byKey(const ValueKey('play-scene'));
    final noopiBefore = tester.getCenter(noopi);
    await tester.pump(const Duration(milliseconds: 900));
    final noopiDelta = tester.getCenter(noopi) - noopiBefore;
    expect(noopiDelta.distance, greaterThan(1));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('reduced motion keeps characters still', (tester) async {
    await tester.pumpWidget(splash());
    final noopi = find.byKey(const ValueKey('play-scene'));
    final before = tester.getCenter(noopi);
    await tester.pump(const Duration(milliseconds: 900));
    expect(tester.getCenter(noopi), before);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
