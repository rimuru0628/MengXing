import 'package:flutter/material.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../shared/models/streak.dart';

class StreakBanner extends StatelessWidget {
  final StreakData streak;
  const StreakBanner({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5A0E3A), Color(0xFF2E0A52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KColors.accent.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: KColors.accent.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${streak.currentStreak} Day Streak! 🖤',
                  style: const TextStyle(
                    color: KColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Keep going — you're on fire!",
                  style: TextStyle(
                    color: KColors.accent.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${streak.longestStreak}',
                style: const TextStyle(
                  color: KColors.neonBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const Text(
                'best',
                style: TextStyle(color: KColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
