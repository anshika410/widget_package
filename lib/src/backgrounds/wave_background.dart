import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Layered sine waves that roll across the bottom of the screen.
class WaveBackground extends StatefulWidget {
  const WaveBackground({
    super.key,
    this.waveColor = Colors.white,
    this.backgroundColor = const Color(0xFF0F2027),
    this.layers = 3,
    this.amplitude = 24,
    this.duration = const Duration(seconds: 8),
    this.heightFactor = 0.35,
    this.child,
  }) : assert(layers >= 1);

  final Color waveColor;
  final Color backgroundColor;

  /// Number of overlapping wave layers.
  final int layers;

  /// Wave height in logical pixels.
  final double amplitude;
  final Duration duration;

  /// How much of the screen height the waves occupy (0..1).
  final double heightFactor;
  final Widget? child;

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

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
        ColoredBox(color: widget.backgroundColor),
        RepaintBoundary(
          child: CustomPaint(
            painter: _WavePainter(
              repaint: _controller,
              progress: () => _controller.value,
              color: widget.waveColor,
              layers: widget.layers,
              amplitude: widget.amplitude,
              heightFactor: widget.heightFactor,
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required Listenable repaint,
    required this.progress,
    required this.color,
    required this.layers,
    required this.amplitude,
    required this.heightFactor,
  }) : super(repaint: repaint);

  final double Function() progress;
  final Color color;
  final int layers;
  final double amplitude;
  final double heightFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress();
    for (var i = 0; i < layers; i++) {
      final path = Path();
      final baseY = size.height * (1 - heightFactor) + i * (amplitude * 0.8);
      // Odd layers travel the opposite way; a full 2π per loop keeps it seamless.
      final direction = i.isEven ? 1 : -1;
      final phase = p * math.pi * 2 * direction + i * 1.2;
      final frequency = 1.0 + i * 0.5;

      path.moveTo(0, size.height);
      path.lineTo(0, baseY);
      for (double x = 0; x <= size.width; x += 4) {
        final y =
            baseY +
            math.sin((x / size.width) * math.pi * 2 * frequency + phase) *
                (amplitude / (1 + i * 0.3));
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(
        path,
        Paint()..color = color.withValues(alpha: 0.12 + i * 0.08),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) =>
      old.color != color ||
      old.layers != layers ||
      old.amplitude != amplitude ||
      old.heightFactor != heightFactor;
}
