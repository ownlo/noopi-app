import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

// Render the existing noopi-web SVG mark without its background for Android's
// adaptive foreground. Coordinates and strokes match assets/brand/app-icon.svg.
void main() {
  test('render NOOPI brand foreground', () async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final mark = ui.Path()
      ..moveTo(327, 733)
      ..lineTo(327, 291)
      ..lineTo(697, 733)
      ..lineTo(697, 291);
    final diagonal = ui.Path()
      ..moveTo(327, 291)
      ..lineTo(697, 733);
    ui.Paint stroke(ui.Color color, double width) => ui.Paint()
      ..color = color
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = ui.StrokeCap.round
      ..strokeJoin = ui.StrokeJoin.round;
    canvas.save();
    canvas.translate(512, 512);
    canvas.rotate(-4 * math.pi / 180);
    canvas.translate(-512, -512);
    canvas.save();
    canvas.translate(0, 28);
    canvas.drawPath(
      mark,
      stroke(const ui.Color(0x6B1B106F), 126)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 25),
    );
    canvas.restore();
    canvas.drawPath(mark, stroke(const ui.Color(0xFFFFFFFF), 126));
    canvas.drawPath(diagonal, stroke(const ui.Color(0xFFF8F5FF), 76));
    canvas.restore();
    final picture = recorder.endRecording();
    final rendered = await picture.toImage(1024, 1024);
    final bytes = await rendered.toByteData(format: ui.ImageByteFormat.png);
    File('assets/brand/app-icon-foreground.png')
        .writeAsBytesSync(bytes!.buffer.asUint8List());
    rendered.dispose();
    picture.dispose();
  });
}
