import 'package:flutter/material.dart';

class MouseGlowWrapper extends StatefulWidget {
  final Widget child;
  const MouseGlowWrapper({super.key, required this.child});

  @override
  State<MouseGlowWrapper> createState() => _MouseGlowWrapperState();
}

class _MouseGlowWrapperState extends State<MouseGlowWrapper> {
  Offset _mousePosition = Offset.zero;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Only track hover on desktop/web screens where mouse pointer is active
    final width = MediaQuery.of(context).size.width;
    if (width < 800) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final glowColor = theme.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
        });
      },
      child: Stack(
        children: [
          // Content
          widget.child,
          
          // Glow overlay
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
        ],
      ),
    );
  }
}

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
          glowColor.withOpacity(0.12),
          glowColor.withOpacity(0.04),
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
