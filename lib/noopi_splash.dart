import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Text-free loading scene featuring all three NOOPI characters.
class NoopiSplash extends StatefulWidget {
  const NoopiSplash({super.key});

  @override
  State<NoopiSplash> createState() => _NoopiSplashState();
}

class _NoopiSplashState extends State<NoopiSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _motion.stop();
      _motion.value = 0;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: '누피, 우피, 당비가 게임을 준비하고 있어요',
    liveRegion: true,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF101426),
        gradient: RadialGradient(
          center: Alignment(0, -.08),
          radius: .78,
          colors: [Color(0xFF22203B), Color(0xFF101426)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 360,
              height: 480,
              child: AnimatedBuilder(
                animation: _motion,
                builder: (context, _) {
                  final phase = _motion.value * math.pi * 2;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _AmbientPainter(phase)),
                      ),
                      Positioned(
                        left: 0,
                        top: 40,
                        child: Transform.translate(
                          offset: Offset(0, math.sin(phase) * 5),
                          child: Transform.scale(
                            scale: .985 + math.sin(phase) * .015,
                            child: Image.asset(
                              'assets/brand/play-together.png',
                              key: const ValueKey('play-scene'),
                              width: 360,
                              height: 360,
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 152,
                        top: 432,
                        child: Row(
                          children: List.generate(3, (index) {
                            final pulse =
                                (math.sin(phase - index * .8) + 1) / 2;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Transform.scale(
                                scale: .8 + pulse * .35,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFB8AEDE)
                                        .withValues(alpha: .25 + pulse * .45),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _AmbientPainter extends CustomPainter {
  const _AmbientPainter(this.phase);
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    const center = Offset(180, 226);
    final glow = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x306A53C7), Color(0x006A53C7)],
      ).createShader(Rect.fromCircle(center: center, radius: 182));
    canvas.drawCircle(center, 182, glow);
    final coolCenter = Offset(242 + math.sin(phase) * 12, 260);
    canvas.drawCircle(
      coolCenter,
      112,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0x143EC7DC), Color(0x003EC7DC)],
        ).createShader(Rect.fromCircle(center: coolCenter, radius: 112)),
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-.24 + math.sin(phase) * .025);
    canvas.drawOval(
      const Rect.fromLTRB(-166, -147, 166, 147),
      Paint()
        ..color = const Color(0x1EADA4D8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8,
    );
    canvas.drawOval(
      const Rect.fromLTRB(-176, -162, 176, 162),
      Paint()
        ..color = const Color(0x09ADA4D8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8,
    );
    for (var i = 0; i < 3; i++) {
      final angle = phase + i * math.pi * 2 / 3;
      final point = Offset(math.cos(angle) * 166, math.sin(angle) * 147);
      final color = [
        const Color(0xFFA58DEC),
        const Color(0xFF7FD6E0),
        const Color(0xFFE0C8EC),
      ][i];
      canvas.drawCircle(
        point,
        8,
        Paint()
          ..shader = RadialGradient(
            colors: [color.withValues(alpha: .25), color.withValues(alpha: 0)],
          ).createShader(Rect.fromCircle(center: point, radius: 8)),
      );
      canvas.drawCircle(
        point,
        2.2,
        Paint()..color = color.withValues(alpha: .7),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AmbientPainter oldDelegate) => oldDelegate.phase != phase;
}
