import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/widgets/lottie_widget.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../../shared/widgets/kuro_widgets.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  final String? historyId;
  const WorkoutSummaryScreen({super.key, this.historyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Kuromi nice work + Lottie
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KuroImage(
                      asset: KuromiAssets.niceWork,
                      width: 110,
                      height: 110,
                      fallbackEmoji: '💪',
                    ),
                    const SizedBox(width: 8),
                    SafeLottie(
                      asset: 'assets/animations/success.json',
                      height: 110,
                      width: 110,
                      repeat: false,
                    ),
                  ],
                ),

                ShaderMask(
                  shaderCallback: (b) =>
                      KColors.neonGradient.createShader(b),
                  child: Text(
                    s.workoutCompleteTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  s.workoutCompleteMsg,
                  style: TextStyle(
                      color: KColors.textSecondary,
                      fontSize: 14,
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _WoStat(
                          emoji: '⏱',
                          label: s.durationLabel,
                          value: '~30 min',
                          color: KColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WoStat(
                          emoji: '🔥',
                          label: s.caloriesLabel,
                          value: '~180 kcal',
                          color: KColors.calorieColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _WoStat(
                          emoji: '💪',
                          label: s.exercisesCount,
                          value: s.doneLabel,
                          color: KColors.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WoStat(
                          emoji: '⭐',
                          label: 'Status',
                          value: s.workoutCompleteTitle,
                          color: KColors.progressColor),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: KColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: KColors.primary.withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Calorie estimates are approximations. Always warm up and cool down properly.',
                          style: TextStyle(
                              color: KColors.textSecondary,
                              fontSize: 12,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                KuroButton(
                  label: s.backToExerciseBtn,
                  icon: Icons.fitness_center_rounded,
                  onPressed: () => context.go(AppRoutes.exercise),
                ),
                const SizedBox(height: 12),
                KuroButton(
                  label: s.viewHistoryBtn,
                  outlined: true,
                  onPressed: () => context.push('/exercise/history'),
                ),
                const SizedBox(height: 20),
                KuroSparkleRow(text: s.restRecoverMsg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WoStat extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _WoStat(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          Text(label,
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
