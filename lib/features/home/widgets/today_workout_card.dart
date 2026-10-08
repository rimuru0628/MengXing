import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../exercise/providers/exercise_provider.dart';

class TodayWorkoutCard extends ConsumerWidget {
  final bool workoutCompleted;
  const TodayWorkoutCard({super.key, required this.workoutCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final workout = ref.watch(todayWorkoutProvider);

    return GestureDetector(
      onTap: () => context.push('/exercise/player', extra: null),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: workoutCompleted
                ? [const Color(0xFF0A3A2A), const Color(0xFF1A0A2E)]
                : [const Color(0xFF2A0E52), const Color(0xFF1A0A2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: workoutCompleted
                ? KColors.progressColor.withOpacity(0.35)
                : KColors.primary.withOpacity(0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: (workoutCompleted ? KColors.progressColor : KColors.primary)
                  .withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: (workoutCompleted
                        ? KColors.progressColor
                        : KColors.primary)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (workoutCompleted
                          ? KColors.progressColor
                          : KColors.primary)
                      .withOpacity(0.3),
                ),
              ),
              child: Icon(
                workoutCompleted
                    ? Icons.check_circle_rounded
                    : Icons.fitness_center_rounded,
                color: workoutCompleted
                    ? KColors.progressColor
                    : KColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutCompleted
                        ? s.workoutCompletedCard
                        : s.dailyWorkoutCard,
                    style: TextStyle(
                      color: workoutCompleted
                          ? KColors.progressColor
                          : KColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    workoutCompleted
                        ? s.amazingJobToday
                        : '${workout.length} exercises · ~30 min',
                    style: const TextStyle(
                      color: KColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!workoutCompleted)
              Icon(
                Icons.play_circle_filled_rounded,
                color: KColors.primary.withOpacity(0.8),
                size: 34,
              ),
          ],
        ),
      ),
    );
  }
}
