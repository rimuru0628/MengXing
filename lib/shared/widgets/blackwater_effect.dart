import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated blackwater ripple/wave effect.
/// Deep black-teal water with slow undulating waves and subtle shimmer.
///
/// Usage:
///   BlackwaterEffect(height: 200)                    // standalone
///   BlackwaterBackground(child: YourWidget())        // full background
///   BlackwaterCard(child: YourWidget())              // card with water at bottom
class BlackwaterEffect extends StatefulWidget {
  final double height;
  final double width;
  final int waveCount;
  final bool showRipples;

  const BlackwaterEffect({
    super.key,
    this.height = 120,
    this.width = double.infinity,
    this.waveCount = 3,
    this.showRipples = true,
  });

  @override
  State<BlackwaterEffect> createState() => _BlackwaterEffectState();
}

class _BlackwaterEffectState extends State<BlackwaterEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: Size(
          widget.width == double.infinity
              ? MediaQuery.of(context).size.width
              : widget.width,
          widget.height,
        ),
        painter: _BlackwaterPainter(
          progress: _ctrl.value,
          waveCount: widget.waveCount,
          showRipples: widget.showRipples,
        ),
      ),
    );
  }
}

class _BlackwaterPainter extends CustomPainter {
  final double progress;
  final int waveCount;
  final bool showRipples;

  _BlackwaterPainter({
    required this.progress,
    required this.waveCount,
    required this.showRipples,
  });

  // Blackwater color palette — deep dark water tones
  static const Color _deepBlack = Color(0xFF020408);
  static const Color _darkTeal = Color(0xFF041A1A);
  static const Color _midnight = Color(0xFF050D15);
  static const Color _deepPurple = Color(0xFF0D0520);
  static const Color _shimmer = Color(0xFF0A3040);
  static const Color _highlight = Color(0xFF0E4A5A);

  @override
  void paint(Canvas canvas, Size size) {
    // ── Base gradient fill ──────────────────────────────────────────────────
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _deepPurple.withOpacity(0.95),
          _midnight,
          _deepBlack,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // ── Animated water waves ────────────────────────────────────────────────
    final waveLayers = [
      _WaveLayer(
        color: _darkTeal.withOpacity(0.45),
        amplitude: size.height * 0.08,
        frequency: 1.4,
        speed: progress,
        yOffset: size.height * 0.55,
        phase: 0.0,
      ),
      _WaveLayer(
        color: _shimmer.withOpacity(0.35),
        amplitude: size.height * 0.06,
        frequency: 2.0,
        speed: progress,
        yOffset: size.height * 0.65,
        phase: math.pi * 0.5,
      ),
      _WaveLayer(
        color: _highlight.withOpacity(0.2),
        amplitude: size.height * 0.05,
        frequency: 1.7,
        speed: progress,
        yOffset: size.height * 0.75,
        phase: math.pi * 1.2,
      ),
    ];

    for (final wave in waveLayers) {
      _drawWave(canvas, size, wave);
    }

    // ── Surface shimmer lines ───────────────────────────────────────────────
    _drawShimmerLines(canvas, size);

    // ── Ripple circles ──────────────────────────────────────────────────────
    if (showRipples) {
      _drawRipples(canvas, size);
    }

    // ── Top fade overlay (blends into background above) ────────────────────
    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          _deepBlack.withOpacity(0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height * 0.4), fadePaint);
  }

  void _drawWave(Canvas canvas, Size size, _WaveLayer wave) {
    final path = Path();
    final paint = Paint()
      ..color = wave.color
      ..style = PaintingStyle.fill;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 1) {
      final y = wave.yOffset +
          math.sin((x / size.width * wave.frequency * 2 * math.pi) +
              (wave.speed * 2 * math.pi) +
              wave.phase) *
              wave.amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawShimmerLines(Canvas canvas, Size size) {
    final shimmerProgress = (progress * 3) % 1.0;
    final paint = Paint()
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // 3 slow-moving shimmer lines
    for (int i = 0; i < 3; i++) {
      final lineProgress = (shimmerProgress + i / 3.0) % 1.0;
      final y = size.height * 0.4 + lineProgress * size.height * 0.5;
      final opacity = math.sin(lineProgress * math.pi) * 0.25;

      paint.color = _highlight.withOpacity(opacity);

      // Wavy shimmer line
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x <= size.width; x += 2) {
        final dy = math.sin(x / size.width * math.pi * 4 + progress * 6) * 2;
        path.lineTo(x, y + dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawRipples(Canvas canvas, Size size) {
    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // 4 ripple centers at different positions
    final centers = [
      Offset(size.width * 0.25, size.height * 0.7),
      Offset(size.width * 0.65, size.height * 0.75),
      Offset(size.width * 0.45, size.height * 0.85),
      Offset(size.width * 0.80, size.height * 0.65),
    ];

    for (int i = 0; i < centers.length; i++) {
      final p = (progress + i * 0.25) % 1.0;
      final maxRadius = size.width * 0.12;
      final radius = p * maxRadius;
      final opacity = (1 - p) * 0.3;

      if (opacity > 0.01) {
        ripplePaint.color = _highlight.withOpacity(opacity);
        canvas.drawCircle(centers[i], radius, ripplePaint);

        // Second inner ring
        if (radius > 8) {
          ripplePaint.color = _shimmer.withOpacity(opacity * 0.5);
          canvas.drawCircle(centers[i], radius * 0.6, ripplePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BlackwaterPainter old) => old.progress != progress;
}

class _WaveLayer {
  final Color color;
  final double amplitude;
  final double frequency;
  final double speed;
  final double yOffset;
  final double phase;

  const _WaveLayer({
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.speed,
    required this.yOffset,
    required this.phase,
  });
}

// ─── Full background wrapper ──────────────────────────────────────────────────
/// Wraps a child with a blackwater animated background
class BlackwaterBackground extends StatelessWidget {
  final Widget child;
  final bool subtle; // if true, uses lower opacity

  const BlackwaterBackground({
    super.key,
    required this.child,
    this.subtle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: subtle ? 0.5 : 1.0,
            child: BlackwaterEffect(
              height: MediaQuery.of(context).size.height,
              waveCount: 3,
              showRipples: true,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// ─── Card with water at bottom ────────────────────────────────────────────────
/// Card widget with blackwater waves flowing at the bottom
class BlackwaterCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double waterHeight;
  final Color? backgroundColor;

  const BlackwaterCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.waterHeight = 60,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          // Card background
          Container(
            color: backgroundColor ?? const Color(0xFF0D0520),
          ),
          // Water waves at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlackwaterEffect(
              height: waterHeight,
              showRipples: false,
            ),
          ),
          // Content on top
          child,
        ],
      ),
    );
  }
}

// ─── Thin wave divider ────────────────────────────────────────────────────────
/// A thin animated wave strip used as a section separator
class BlackwaterDivider extends StatelessWidget {
  final double height;

  const BlackwaterDivider({super.key, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return BlackwaterEffect(
      height: height,
      waveCount: 2,
      showRipples: false,
    );
  }
}
