import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/widgets/lottie_widget.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../../core/l10n/locale_provider.dart';
import '../providers/walk_provider.dart';

class WalkSummaryScreen extends ConsumerWidget {
  final String? sessionId;
  const WalkSummaryScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walkState = ref.watch(walkNotifierProvider);
    final s = ref.watch(stringsProvider);
    final session = walkState.session;

    if (session == null) {
      return Scaffold(
        backgroundColor: KColors.bg,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No walk data',
                  style: TextStyle(color: KColors.textPrimary)),
              const SizedBox(height: 16),
              KuroButton(
                  label: 'Go Back',
                  onPressed: () => context.go(AppRoutes.walk)),
            ],
          ),
        ),
      );
    }

    final duration = Duration(seconds: session.durationSeconds);

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

                // Kuromi celebrating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KuroImage(
                      asset: KuromiAssets.great,
                      width: 110,
                      height: 110,
                      fallbackEmoji: '🎉',
                    ),
                    const SizedBox(width: 8),
                    // Lottie success beside kuromi
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
                    s.walkCompleteTitle,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppDateUtils.formatDateTime(session.startTime),
                  style: const TextStyle(
                      color: KColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 28),

                // Stats grid
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                  children: [
                    _SumStat(
                        emoji: '👟',
                        label: 'Steps',
                        value: FitnessUtils.formatStepsFull(
                            session.steps),
                        color: KColors.neonBlue),
                    _SumStat(
                        emoji: '📍',
                        label: 'Distance',
                        value: FitnessUtils.formatDistance(
                            session.distanceKm),
                        color: KColors.walkColor),
                    _SumStat(
                        emoji: '⏱',
                        label: 'Duration',
                        value: AppDateUtils.formatDuration(duration),
                        color: KColors.neonPurple),
                    _SumStat(
                        emoji: '⚡',
                        label: 'Pace',
                        value: FitnessUtils.formatPace(
                            session.paceMinPerKm),
                        color: KColors.accent),
                    _SumStat(
                        emoji: '🔥',
                        label: 'Calories',
                        value:
                            '${session.calories.toStringAsFixed(0)} kcal',
                        color: KColors.calorieColor),
                    _SumStat(
                        emoji: '📡',
                        label: s.method,
                        value: session.trackingMethod.name,
                        color: KColors.primary),
                  ],
                ),

                const SizedBox(height: 24),

                // Disclaimer
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
                      Text('💡',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Step and distance measurements are estimates. Calories are approximations.',
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
                  label: s.saveWalkBtn,
                  icon: Icons.save_rounded,
                  onPressed: () async {
                    await ref
                        .read(walkNotifierProvider.notifier)
                        .saveSession(session);
                    if (!context.mounted) return;
                    context.go(AppRoutes.walk);
                  },
                ),
                const SizedBox(height: 12),
                KuroButton(
                  label: s.discardWalkBtn,
                  outlined: true,
                  onPressed: () {
                    ref.read(walkNotifierProvider.notifier).reset();
                    context.go(AppRoutes.walk);
                  },
                ),
                const SizedBox(height: 20),
                KuroSparkleRow(text: s.everyStepCountsMsg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SumStat extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _SumStat(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 11),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
