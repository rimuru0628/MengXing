import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final String centerText;
  final String centerLabel;
  final Color color;
  final double size;
  final double strokeWidth;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    required this.centerText,
    required this.centerLabel,
    this.color = AppColors.primary,
    this.size = 160,
    this.strokeWidth = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _CircleProgressPainter(
              progress: progress.clamp(0.0, 1.0),
              color: color,
              strokeWidth: strokeWidth,
              trackColor: color.withOpacity(0.12),
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText,
                style: AppTextStyles.statNumber(
                  size: size * 0.18,
                  color: color,
                ),
              ),
              Text(
                centerLabel,
                style: AppTextStyles.statUnit(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi * progress,
        false,
        Paint()
          ..shader = SweepGradient(
            colors: [color.withOpacity(0.6), color],
            startAngle: startAngle,
            endAngle: startAngle + 2 * math.pi * progress,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) =>
      old.progress != progress || old.color != color;
}
