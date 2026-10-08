import 'package:flutter/material.dart';

/// All Kuromi asset paths in one place
class KuromiAssets {
  KuromiAssets._();

  static const String walking = 'assets/kuromi/kuromi_walking.gif';
  static const String walkingStill = 'assets/kuromi/kuromi_walking_still.webp';
  static const String great = 'assets/kuromi/kuromi_great.webp';
  static const String niceWork = 'assets/kuromi/kuromi_nice_work.webp';
  static const String thanks = 'assets/kuromi/kuromi_thanks.webp';
  static const String chilling = 'assets/kuromi/kuromi_chilling.webp';
  static const String cute = 'assets/kuromi/kuromi_cute.webp';
  static const String classic = 'assets/kuromi/kuromi_classic.webp';
  static const String happy = 'assets/kuromi/kuromi_happy.webp';
  static const String blush = 'assets/kuromi/kuromi_blush.webp';
  static const String blankStare = 'assets/kuromi/kuromi_blank_stare.gif';
  static const String peek = 'assets/kuromi/kuromi_peek.webp';
}

/// Safe image widget — gracefully falls back to emoji if image fails
class KuroImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackEmoji;

  const KuroImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallbackEmoji = '🖤',
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            fallbackEmoji,
            style: TextStyle(fontSize: (height ?? width ?? 40) * 0.6),
          ),
        ),
      ),
    );
  }
}
