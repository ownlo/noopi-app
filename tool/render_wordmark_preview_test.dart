import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:noopi_app/noopi_splash.dart';

void main() {
  testWidgets('render 3D app-logo intro preview', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    final gif = img.GifEncoder();
    await tester.pumpWidget(
      MaterialApp(
        home: RepaintBoundary(
          key: key,
          child: const Scaffold(body: NoopiSplash()),
        ),
      ),
    );
    for (var frame = 0; frame <= 56; frame++) {
      if (frame > 0) await tester.pump(const Duration(milliseconds: 50));
      await tester.runAsync(() async {
        final rendered =
            await (key.currentContext!.findRenderObject()
                    as RenderRepaintBoundary)
                .toImage();
        final data = await rendered.toByteData(format: ui.ImageByteFormat.png);
        final bytes = data!.buffer.asUint8List();
        gif.addFrame(img.decodePng(bytes)!, duration: 5);
        if (frame == 18 || frame == 48) {
          File('build/noopi-app-logo-${frame == 18 ? 'motion' : 'settled'}.png')
              .writeAsBytesSync(bytes);
        }
        rendered.dispose();
      });
    }
    File('build/noopi-app-logo-preview.gif').writeAsBytesSync(gif.finish()!);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
