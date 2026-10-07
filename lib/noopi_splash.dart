import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A one-shot 3D app-icon intro, followed by a still loading logo.
class NoopiSplash extends StatefulWidget {
  const NoopiSplash({super.key, this.onComplete});

  static const duration = Duration(milliseconds: 2400);
  final VoidCallback? onComplete;

  @override
  State<NoopiSplash> createState() => _NoopiSplashState();
}

class _NoopiSplashState extends State<NoopiSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: NoopiSplash.duration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed && !_notified) {
            _notified = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onComplete?.call();
            });
          }
        });
  bool _started = false;
  bool _notified = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_started) {
      _controller.forward();
    }
    _started = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFF101426),
    child: Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(
            280.0,
            math.min(constraints.maxWidth, constraints.maxHeight) * .72,
          );
          return Semantics(
            label: '누피 N 앱 로고',
            image: true,
            child: RepaintBoundary(
              child: CustomPaint(
                key: const ValueKey('noopi-app-logo'),
                size: Size.square(width),
                painter: _AppLogoPainter(_controller),
              ),
            ),
          );
        },
      ),
    ),
  );
}

/// Extruded layers with perspective, lighting and the existing SVG's N path.
class _AppLogoPainter extends CustomPainter {
  _AppLogoPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;
  static const _face = Rect.fromLTWH(-82, -82, 164, 164);
  static final _tile = RRect.fromRectAndRadius(
    _face,
    const Radius.circular(38),
  );
  // Original app-icon.svg coordinates, scaled down and centered.
  static final _mark = Path()
    ..moveTo(-29.625, 35.375)
    ..lineTo(-29.625, -35.375)
    ..lineTo(29.625, 35.375)
    ..lineTo(29.625, -35.375);

  Matrix4 _projection(double yaw, double pitch, double roll, double depth) =>
      Matrix4.identity()
        ..setEntry(3, 2, -.0018)
        ..rotateZ(roll)
        ..rotateY(yaw)
        ..rotateX(pitch)
        ..translateByDouble(0, 0, depth, 1);

  @override
  void paint(Canvas canvas, Size size) {
    final seconds = animation.value * 2.4;
    final entrance = (seconds / .65).clamp(0.0, 1.0);
    final pop = Curves.easeOutBack.transform(entrance);
    final play = ((seconds - .5) / 1.65).clamp(0.0, 1.0);
    final envelope = math.pow(1 - play, 1.2).toDouble();
    final wave = math.sin(play * math.pi * 4);
    final yaw = (1 - entrance) * -1.05 + wave * .85 * envelope;
    final pitch =
        (1 - entrance) * .45 + math.sin(play * math.pi * 3) * .42 * envelope;
    final roll =
        (1 - entrance) * -.18 + math.sin(play * math.pi * 4) * .13 * envelope;
    final hop = -math.sin(play * math.pi * 3).abs() * 24 * envelope;
    final squash = math.sin(play * math.pi * 6) * .085 * envelope;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(size.width / 280);
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, 104),
        width: 128 - hop,
        height: 14,
      ),
      Paint()
        ..color = const Color(0xFF080914).withValues(alpha: .48 * entrance)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.translate(0, hop + (1 - entrance) * 28);
    canvas.scale(pop * (1 + squash), pop * (1 - squash));

    // Back-to-front depth slices create solid sides while the icon turns.
    for (var depth = -24; depth < 0; depth++) {
      canvas.save();
      canvas.transform(_projection(yaw, pitch, roll, depth.toDouble()).storage);
      canvas.drawRRect(
        _tile,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF2C1D78),
            const Color(0xFF8251E9),
            (depth + 24) / 24,
          )!.withValues(alpha: entrance),
      );
      canvas.restore();
    }
    canvas.save();
    canvas.transform(_projection(yaw, pitch, roll, 0).storage);
    canvas.drawRRect(
      _tile,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFA655FF),
            const Color(0xFF6540E8),
            const Color(0xFF2536B9),
          ].map((color) => color.withValues(alpha: entrance)).toList(),
          stops: const [0, .48, 1],
        ).createShader(_face),
    );
    canvas.drawRRect(
      _tile.deflate(1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .45 * entrance),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(_face),
    );
    canvas.restore();

    for (var depth = 0; depth <= 7; depth++) {
      canvas.save();
      canvas.transform(_projection(yaw, pitch, roll, depth.toDouble()).storage);
      canvas.rotate(-4 * math.pi / 180);
      if (depth == 0) {
        canvas.save();
        canvas.translate(0, 4.5);
        canvas.drawPath(
          _mark,
          Paint()
            ..color = const Color(0xFF1B106F).withValues(alpha: .42 * entrance)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 20.16
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.restore();
      }
      canvas.drawPath(
        _mark,
        Paint()
          ..color = (depth == 7 ? Colors.white : const Color(0xFFBBB0E4))
              .withValues(alpha: entrance)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20.16
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_AppLogoPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
