import 'dart:math';
import 'package:flutter/material.dart';

class AINetworkBackground extends StatefulWidget {
  const AINetworkBackground({super.key, this.intensity = 0.6});

  final double intensity; // 0..1 visual strength

  @override
  State<AINetworkBackground> createState() => _AINetworkBackgroundState();
}

class _AINetworkBackgroundState extends State<AINetworkBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_AiNode> _nodes;
  final _rand = Random(7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
    _nodes = List.generate(36, (i) => _AiNode.random(_rand));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SizedBox(
            width: double.infinity,
            child: CustomPaint(
              painter: _AiPainter(
                nodes: _nodes,
                t: _controller.value,
                baseColor: theme.colorScheme.primary,
                accent: theme.colorScheme.tertiary,
                onSurface: theme.colorScheme.onSurface,
                intensity: widget.intensity,
                isLight: isLight,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AiNode {
  _AiNode(this.anchor, this.r, this.speed);

  factory _AiNode.random(Random rand) {
    final a = Offset(rand.nextDouble(), rand.nextDouble());
    final r = lerpDouble(2, 4.5, rand.nextDouble());
    final s = lerpDouble(0.2, 1.0, rand.nextDouble());
    return _AiNode(a, r, s);
  }

  final Offset anchor; // 0..1 in both axis
  final double? r; // base radius
  final double? speed; // movement speed factor

  Offset position(Size size, double t) {
    final px = anchor.dx + 0.02 * sin((anchor.dx + t * (speed ?? 1)) * pi * 2);
    final py = anchor.dy + 0.02 * cos((anchor.dy + t * (speed ?? 1)) * pi * 2);
    return Offset(px * size.width, py * size.height);
  }
}

class _AiPainter extends CustomPainter {
  _AiPainter({
    required this.nodes,
    required this.t,
    required this.baseColor,
    required this.accent,
    required this.onSurface,
    required this.intensity,
    required this.isLight,
  });

  final List<_AiNode> nodes;
  final double t;
  final Color baseColor;
  final Color accent;
  final Color onSurface;
  final double intensity;
  final bool isLight;

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle radial vignette backdrop
    final bg = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        radius: 1.2,
        colors: [
          baseColor.withValues(alpha: 0.08 * intensity),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    // Prepare dynamic colors based on brightness
    final Color lineBase = isLight
        ? accent.withValues(alpha: 0.16 * intensity)
        : onSurface.withValues(alpha: 0.12 * intensity);
    final Color lineBlendTarget = isLight
        ? onSurface.withValues(alpha: 0.15 * intensity)
        : accent.withValues(alpha: 0.20 * intensity);

    final linePaint = Paint()
      ..color = lineBase
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..strokeWidth = 1.2
      ..color = (isLight
              ? accent.withValues(alpha: 0.22 * intensity)
              : baseColor.withValues(alpha: 0.18 * intensity))
          .withValues(alpha: (isLight ? 0.22 : 0.18) * intensity)
      ..style = PaintingStyle.stroke;

    final positions = nodes.map((n) => n.position(size, t)).toList();

    for (var i = 0; i < positions.length; i++) {
      for (var j = i + 1; j < positions.length; j++) {
        final p1 = positions[i];
        final p2 = positions[j];
        final d = (p1 - p2).distance;
        // Connect near nodes; stronger on the left half
        final threshold = size.width * 0.22 + size.height * 0.08;
        if (d < threshold) {
          final strength = (1 - (d / threshold)).clamp(0.0, 1.0);
          final c = Color.lerp(lineBase, lineBlendTarget, strength)!;
          final lp = linePaint..color = c;
          canvas.drawLine(p1, p2, lp);
          canvas.drawLine(p1, p2, glowPaint);
        }
      }
    }

    // Draw nodes
    for (var i = 0; i < positions.length; i++) {
      final p = positions[i];
      // Size bias to left: larger near left for visual interest
      final bias = 1.0 - (p.dx / size.width);
      final r = (nodes[i].r ?? 3) * (0.8 + 0.6 * bias);

      final nodeCore = Paint()
        ..color = (isLight
            ? onSurface.withValues(alpha: 0.90)
            : accent.withValues(alpha: 0.90))
        ..style = PaintingStyle.fill;

      final nodeGlow = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
        ..color = (isLight
            ? baseColor.withValues(alpha: 0.25 * intensity)
            : baseColor.withValues(alpha: 0.35 * intensity));

      // halo
      canvas.drawCircle(p, r * 2.4, nodeGlow);
      // core
      canvas.drawCircle(p, r, nodeCore);
    }

    // Soft top-left to bottom-right sweep
    final sweep = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.04 * intensity),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sweep);
  }

  @override
  bool shouldRepaint(covariant _AiPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.baseColor != baseColor ||
      oldDelegate.accent != accent ||
      oldDelegate.onSurface != onSurface ||
      oldDelegate.intensity != intensity ||
      oldDelegate.isLight != isLight;
}

// Helper for double lerp without importing dart:ui as ui
double? lerpDouble(num a, num b, double t) => a + (b - a) * t;
