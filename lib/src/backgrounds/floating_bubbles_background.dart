import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Soft translucent bubbles that float upward forever.
class FloatingBubblesBackground extends StatefulWidget {
  const FloatingBubblesBackground({
    super.key,
    this.bubbleCount = 18,
    this.bubbleColor = Colors.white,
    this.backgroundColor,
    this.duration = const Duration(seconds: 20),
    this.seed = 7,
    this.child,
  });

  final int bubbleCount;
  final Color bubbleColor;

  /// Optional solid color painted behind the bubbles.
  final Color? backgroundColor;

  /// Base loop time; individual bubbles move at different speeds.
  final Duration duration;

  /// Same seed = same bubble layout (handy for tests).
  final int seed;
  final Widget? child;

  @override
  State<FloatingBubblesBackground> createState() =>
      _FloatingBubblesBackgroundState();
}

class _FloatingBubblesBackgroundState extends State<FloatingBubblesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  late List<_Bubble> _bubbles = _generate();

  List<_Bubble> _generate() {
    final rnd = math.Random(widget.seed);
    return List.generate(widget.bubbleCount, (_) {
      return _Bubble(
        x: rnd.nextDouble(),
        radius: 6 + rnd.nextDouble() * 26,
        // Integer speeds keep the loop seamless.
        speed: 1 + rnd.nextInt(3),
        phase: rnd.nextDouble(),
        drift: 0.01 + rnd.nextDouble() * 0.04,
        opacity: 0.08 + rnd.nextDouble() * 0.22,
      );
    });
  }

  @override
  void didUpdateWidget(covariant FloatingBubblesBackground old) {
    super.didUpdateWidget(old);
    if (old.bubbleCount != widget.bubbleCount || old.seed != widget.seed) {
      _bubbles = _generate();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.backgroundColor != null)
          ColoredBox(color: widget.backgroundColor!),
        RepaintBoundary(
          child: CustomPaint(
            painter: _BubblePainter(
              repaint: _controller,
              progress: () => _controller.value,
              bubbles: _bubbles,
              color: widget.bubbleColor,
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _Bubble {
  const _Bubble({
    required this.x,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.drift,
    required this.opacity,
  });
  final double x, radius, phase, drift, opacity;
  final int speed;
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({
    required Listenable repaint,
    required this.progress,
    required this.bubbles,
    required this.color,
  }) : super(repaint: repaint);

  final double Function() progress;
  final List<_Bubble> bubbles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress();
    final paint = Paint();
    for (final b in bubbles) {
      final t = (p * b.speed + b.phase) % 1.0;
      final y = size.height * (1.1 - t * 1.2); // rises from below to above
      final x =
          size.width * b.x + math.sin(t * math.pi * 2) * b.drift * size.width;
      paint.color = color.withValues(alpha: b.opacity);
      canvas.drawCircle(Offset(x, y), b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter old) =>
      old.bubbles != bubbles || old.color != color;
}
