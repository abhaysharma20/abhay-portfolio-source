import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

// ─── Click Effect Models ──────────────────────────────────────────────────────

class _ClickRipple {
  final Offset position;
  final AnimationController controller;
  final Color color;
  _ClickRipple({
    required this.position,
    required this.controller,
    required this.color,
  });
}

class _Particle {
  final Offset origin;
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final AnimationController controller;
  _Particle({
    required this.origin,
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.controller,
  });
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class MouseGlowWrapper extends StatefulWidget {
  final Widget child;
  const MouseGlowWrapper({super.key, required this.child});

  @override
  State<MouseGlowWrapper> createState() => _MouseGlowWrapperState();
}

class _MouseGlowWrapperState extends State<MouseGlowWrapper>
    with TickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  bool _isHovering = false;

  final List<_ClickRipple> _ripples = [];
  final List<_Particle> _particles = [];
  final math.Random _rng = math.Random();

  static const _colors = [
    AppConstants.primaryColor,   // cyan
    AppConstants.secondaryColor, // purple
    AppConstants.accentColor,    // amber
  ];

  // ── Spawn effects on tap ──────────────────────────────────────────────────
  void _onTapDown(TapDownDetails details) {
    final pos = details.localPosition;
    final color = _colors[_rng.nextInt(_colors.length)];

    // 2 concentric expanding rings
    for (int i = 0; i < 2; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 550 + i * 150),
      );
      final ripple = _ClickRipple(position: pos, controller: ctrl, color: color);
      ctrl.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _ripples.remove(ripple));
          ctrl.dispose();
        }
      });
      setState(() => _ripples.add(ripple));
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) ctrl.forward();
      });
    }

    // 8 floating dot particles bursting outward
    const particleCount = 8;
    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * math.pi / particleCount) * i +
          _rng.nextDouble() * 0.4 - 0.2;
      final speed = 55.0 + _rng.nextDouble() * 60;
      final size = 3.0 + _rng.nextDouble() * 4;
      final pColor = _colors[_rng.nextInt(_colors.length)];
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );
      final p = _Particle(
        origin: pos,
        angle: angle,
        speed: speed,
        size: size,
        color: pColor,
        controller: ctrl,
      );
      ctrl.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _particles.remove(p));
          ctrl.dispose();
        }
      });
      setState(() => _particles.add(p));
      ctrl.forward();
    }
  }

  @override
  void dispose() {
    for (final r in _ripples) {
      r.controller.dispose();
    }
    for (final p in _particles) {
      p.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glowColor = theme.primaryColor;

    return GestureDetector(
      onTapDown: _onTapDown,
      behavior: HitTestBehavior.translucent,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        onHover: (event) => setState(() => _mousePosition = event.localPosition),
        child: Stack(
          children: [
            // ── Main content ───────────────────────────────────────────
            widget.child,

            // ── Cursor glow follow ─────────────────────────────────────
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _isHovering ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: GlowPainter(_mousePosition, glowColor),
                ),
              ),
            ),

            // ── Click ripples ──────────────────────────────────────────
            IgnorePointer(
              child: Stack(
                children: _ripples.map((r) {
                  return AnimatedBuilder(
                    animation: r.controller,
                    builder: (_, __) {
                      final t = CurvedAnimation(
                        parent: r.controller,
                        curve: Curves.easeOut,
                      ).value;
                      final radius = t * 80;
                      final opacity = (1.0 - t).clamp(0.0, 1.0);
                      return Positioned(
                        left: r.position.dx - radius,
                        top: r.position.dy - radius,
                        child: Container(
                          width: radius * 2,
                          height: radius * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: r.color.withOpacity(opacity * 0.7),
                              width: (2.0 * (1 - t)).clamp(0.5, 2.0),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // ── Floating particles ─────────────────────────────────────
            IgnorePointer(
              child: Stack(
                children: _particles.map((p) {
                  return AnimatedBuilder(
                    animation: p.controller,
                    builder: (_, __) {
                      final t = CurvedAnimation(
                        parent: p.controller,
                        curve: Curves.easeOut,
                      ).value;
                      final dx = math.cos(p.angle) * p.speed * t;
                      final dy = math.sin(p.angle) * p.speed * t - 30 * t;
                      final opacity = (1.0 - t).clamp(0.0, 1.0);
                      return Positioned(
                        left: p.origin.dx + dx - p.size / 2,
                        top: p.origin.dy + dy - p.size / 2,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: p.size,
                            height: p.size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.color.withOpacity(0.85),
                              boxShadow: [
                                BoxShadow(
                                  color: p.color.withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cursor glow painter ──────────────────────────────────────────────────────

class GlowPainter extends CustomPainter {
  final Offset position;
  final Color glowColor;
  GlowPainter(this.position, this.glowColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (position.dx / size.width) * 2 - 1,
          (position.dy / size.height) * 2 - 1,
        ),
        radius: 0.35,
        colors: [
          glowColor.withOpacity(0.10),
          glowColor.withOpacity(0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(GlowPainter oldDelegate) =>
      position != oldDelegate.position || glowColor != oldDelegate.glowColor;
}
