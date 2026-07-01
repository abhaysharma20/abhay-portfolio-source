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
    AppConstants.primaryColor,    // neon cyan
    AppConstants.secondaryColor,  // deep purple
    AppConstants.accentColor,     // electric amber
  ];

  // ── Spawn on pointer down (Listener — never swallowed by ScrollView) ────
  void _onPointerDown(Offset localPos) {
    final color = _colors[_rng.nextInt(_colors.length)];

    // 2 concentric expanding ring ripples
    for (int i = 0; i < 2; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500 + i * 160),
      );
      final ripple = _ClickRipple(position: localPos, controller: ctrl, color: color);
      ctrl.addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          if (mounted) setState(() => _ripples.remove(ripple));
          ctrl.dispose();
        }
      });
      setState(() => _ripples.add(ripple));
      Future.delayed(Duration(milliseconds: i * 90), () {
        if (mounted) ctrl.forward();
      });
    }

    // 8 glowing dot particles bursting radially
    for (int i = 0; i < 8; i++) {
      final angle = (2 * math.pi / 8) * i + _rng.nextDouble() * 0.5 - 0.25;
      final speed = 55.0 + _rng.nextDouble() * 65;
      final size = 3.5 + _rng.nextDouble() * 4.5;
      final pColor = _colors[_rng.nextInt(_colors.length)];
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
      );
      final p = _Particle(
        origin: localPos,
        angle: angle,
        speed: speed,
        size: size,
        color: pColor,
        controller: ctrl,
      );
      ctrl.addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          if (mounted) setState(() => _particles.remove(p));
          ctrl.dispose();
        }
      });
      setState(() => _particles.add(p));
      ctrl.forward();
    }
  }

  @override
  void dispose() {
    for (final r in _ripples) { r.controller.dispose(); }
    for (final p in _particles) { p.controller.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glowColor = theme.primaryColor;

    // Use Listener instead of GestureDetector — pointer events bypass
    // gesture arena so they're never consumed by ScrollView/other widgets.
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) => _onPointerDown(e.localPosition),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        onHover: (e) => setState(() => _mousePosition = e.localPosition),
        child: Stack(
          children: [
            // ── Main content ────────────────────────────────────────────
            widget.child,

            // ── Cursor glow follow ──────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _isHovering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: CustomPaint(
                    painter: GlowPainter(_mousePosition, glowColor),
                  ),
                ),
              ),
            ),

            // ── Ripple rings — Positioned.fill ensures full-screen canvas ──
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _ripples.map((r) {
                    return AnimatedBuilder(
                      animation: r.controller,
                      builder: (_, __) {
                        final t = CurvedAnimation(
                          parent: r.controller,
                          curve: Curves.easeOut,
                        ).value;
                        final radius = t * 85.0;
                        final opacity = (1.0 - t).clamp(0.0, 1.0);
                        return Positioned(
                          left: r.position.dx - radius,
                          top: r.position.dy - radius,
                          width: radius * 2,
                          height: radius * 2,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: r.color.withOpacity(opacity * 0.75),
                                width: (2.5 * (1 - t * 0.8)).clamp(0.4, 2.5),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Floating particles — Positioned.fill ensures full-screen canvas
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _particles.map((p) {
                    return AnimatedBuilder(
                      animation: p.controller,
                      builder: (_, __) {
                        final t = CurvedAnimation(
                          parent: p.controller,
                          curve: Curves.easeOut,
                        ).value;
                        final dx = math.cos(p.angle) * p.speed * t;
                        final dy = math.sin(p.angle) * p.speed * t - 35 * t;
                        final opacity = (1.0 - t).clamp(0.0, 1.0);
                        return Positioned(
                          left: p.origin.dx + dx - p.size / 2,
                          top: p.origin.dy + dy - p.size / 2,
                          width: p.size,
                          height: p.size,
                          child: Opacity(
                            opacity: opacity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: p.color.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: p.color.withOpacity(0.55),
                                    blurRadius: 8,
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
    if (size.isEmpty) return;
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
  bool shouldRepaint(GlowPainter old) =>
      position != old.position || glowColor != old.glowColor;
}
