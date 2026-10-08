import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/kuromi_theme.dart';

/// Safe Lottie wrapper — shows a styled fallback instead of the red error box
class SafeLottie extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit fit;

  const SafeLottie({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: repeat,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Graceful fallback — never show Flutter's red error box
        if (asset.contains('loading')) {
          return _LoadingFallback(
              size: height ?? width ?? 80);
        } else if (asset.contains('success')) {
          return _SuccessFallback(
              size: height ?? width ?? 120);
        }
        return _ComingSoonFallback(
            size: height ?? width ?? 100);
      },
    );
  }
}

// ─── Animated loading dots ────────────────────────────────────────────────────
class _LoadingFallback extends StatefulWidget {
  final double size;
  const _LoadingFallback({required this.size});

  @override
  State<_LoadingFallback> createState() => _LoadingFallbackState();
}

class _LoadingFallbackState extends State<_LoadingFallback>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.size * 0.8,
                height: widget.size * 0.8,
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 3,
                  color: KColors.primary
                      .withOpacity(0.6 + 0.4 * _ctrl.value),
                ),
              ),
              Text(
                '✦',
                style: TextStyle(
                  color: KColors.accent,
                  fontSize: widget.size * 0.2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Success checkmark ────────────────────────────────────────────────────────
class _SuccessFallback extends StatefulWidget {
  final double size;
  const _SuccessFallback({required this.size});

  @override
  State<_SuccessFallback> createState() => _SuccessFallbackState();
}

class _SuccessFallbackState extends State<_SuccessFallback>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [KColors.progressColor, KColors.walkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: KColors.progressColor.withOpacity(0.4),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}

// ─── Coming soon sparkle ──────────────────────────────────────────────────────
class _ComingSoonFallback extends StatelessWidget {
  final double size;
  const _ComingSoonFallback({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          '✨',
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
