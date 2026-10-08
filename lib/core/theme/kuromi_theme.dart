import 'package:flutter/material.dart';

/// Kuromi-inspired brand palette used across all screens
class KColors {
  KColors._();

  // Backgrounds
  static const Color bg = Color(0xFF1A0A2E);          // deep royal purple
  static const Color bgSecondary = Color(0xFF120820);  // darker bg
  static const Color card = Color(0xFF261540);         // card surface
  static const Color cardLight = Color(0xFF321A52);    // lighter card
  static const Color inputFill = Color(0xFF2D1B4E);    // input background

  // Brand colors
  static const Color primary = Color(0xFFB44FD8);      // purple-pink
  static const Color primaryDark = Color(0xFF8A2DBF);  // darker purple
  static const Color accent = Color(0xFFFF6EB4);       // hot pink
  static const Color accentDark = Color(0xFFE0408A);   // deeper pink
  static const Color neonBlue = Color(0xFF7DE8FF);     // neon blue
  static const Color neonPurple = Color(0xFFD0A0FF);   // soft neon purple

  // Text
  static const Color textPrimary = Color(0xFFF5E6FF);  // soft white-purple
  static const Color textSecondary = Color(0xFFAA88CC); // muted purple
  static const Color textHint = Color(0xFF6B4A8A);     // dim purple

  // Borders & dividers
  static const Color border = Color(0xFF6B3FA0);
  static const Color divider = Color(0xFF3D2060);

  // Status
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFFF6EB4);        // pink for errors
  static const Color warning = Color(0xFFFFD166);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [bg, Color(0xFF2A0E4A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonBlue, primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [card, cardLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category colors
  static const Color walkColor = Color(0xFF7DE8FF);    // neon blue
  static const Color exerciseColor = Color(0xFFB44FD8); // purple
  static const Color progressColor = Color(0xFF4ADE80); // green
  static const Color streakColor = Color(0xFFFF6EB4);  // pink
  static const Color calorieColor = Color(0xFFFFD166); // yellow
}

/// Reusable Kuromi-styled card decoration
BoxDecoration kuroCard({
  double radius = 20,
  bool glow = false,
  Color? glowColor,
}) =>
    BoxDecoration(
      color: KColors.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: KColors.border.withOpacity(0.35)),
      boxShadow: glow
          ? [
              BoxShadow(
                color: (glowColor ?? KColors.primary).withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
    );

/// Gradient button decoration
BoxDecoration kuroButtonDecoration({double radius = 14}) => BoxDecoration(
      gradient: KColors.primaryGradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: KColors.primary.withOpacity(0.4),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
