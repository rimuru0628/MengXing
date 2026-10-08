import 'package:flutter/material.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/daily_activity.dart';

class GoalListCard extends StatelessWidget {
  final DailyActivity activity;
  final int stepGoal;
  final double distanceGoal;
  final int activeMinuteGoal;
  final int walkGoal;

  const GoalListCard({
    super.key,
    required this.activity,
    required this.stepGoal,
    required this.distanceGoal,
    required this.activeMinuteGoal,
    required this.walkGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KColors.border.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _GoalRow(
            icon: Icons.directions_walk_rounded,
            color: KColors.neonBlue,
            label:
                '${FitnessUtils.formatStepsFull(activity.steps)} / ${FitnessUtils.formatStepsFull(stepGoal)} Steps',
            progress: FitnessUtils.goalProgress(activity.steps, stepGoal),
          ),
          _KuroDivider(),
          _GoalRow(
            icon: Icons.directions_walk_outlined,
            color: KColors.accent,
            label: '${activity.walkCount} / $walkGoal Walks',
            progress:
                FitnessUtils.goalProgress(activity.walkCount, walkGoal),
          ),
          _KuroDivider(),
          _GoalRow(
            icon: Icons.route_rounded,
            color: KColors.walkColor,
            label:
                '${FitnessUtils.formatDistance(activity.distanceKm)} / ${FitnessUtils.formatDistance(distanceGoal)} Distance',
            progress: FitnessUtils.goalProgress(
                activity.distanceKm, distanceGoal),
          ),
          _KuroDivider(),
          _GoalRow(
            icon: Icons.timer_rounded,
            color: KColors.progressColor,
            label:
                '${activity.activeMinutes} / $activeMinuteGoal Active Min',
            progress: FitnessUtils.goalProgress(
                activity.activeMinutes, activeMinuteGoal),
          ),
          _KuroDivider(),
          _GoalRow(
            icon: Icons.fitness_center_rounded,
            color: KColors.primary,
            label: 'Complete Workout',
            progress: activity.workoutCompleted ? 1.0 : 0.0,
            isBoolean: true,
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double progress;
  final bool isBoolean;

  const _GoalRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.progress,
    this.isBoolean = false,
  });

  @override
  Widget build(BuildContext context) {
    final done = progress >= 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: done ? KColors.progressColor : KColors.textHint,
                size: 20,
              ),
              const SizedBox(width: 10),
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: done
                        ? KColors.textSecondary
                        : KColors.textPrimary,
                    fontSize: 14,
                    decoration:
                        done ? TextDecoration.lineThrough : null,
                    decorationColor: KColors.textSecondary,
                  ),
                ),
              ),
              if (!isBoolean)
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: done ? KColors.progressColor : color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          if (!isBoolean) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _KuroDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        color: KColors.divider,
        height: 1,
        thickness: 1,
      );
}
