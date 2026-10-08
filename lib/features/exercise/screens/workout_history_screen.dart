import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/models/workout_history.dart';
import '../../../shared/providers/services_providers.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../auth/providers/auth_provider.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final uid = ref.watch(currentUserIdProvider);
    final now = DateTime.now();
    final monthStart = AppDateUtils.startOfMonth(now);

    return Scaffold(
      appBar: AppBar(title: Consumer(builder: (c,r,_) => Text(r.watch(stringsProvider).workoutHistoryTitle))),
      body: FutureBuilder<List<WorkoutHistoryEntry>>(
        future: ref
            .read(firestoreServiceProvider)
            .getWorkoutHistoryForRange(uid, monthStart, now),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final workouts = snap.data ?? [];
          if (workouts.isEmpty) {
            return EmptyState(
              icon: Icons.fitness_center_outlined,
              title: 'No workouts this month',
              subtitle: 'Complete a workout to see it here',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: workouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _WorkoutTile(entry: workouts[i]),
          );
        },
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  final WorkoutHistoryEntry entry;
  const _WorkoutTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (entry.isCompleted ? AppColors.accent : AppColors.grey400)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            entry.isCompleted
                ? Icons.check_circle_rounded
                : Icons.incomplete_circle_rounded,
            color: entry.isCompleted ? AppColors.accent : AppColors.grey400,
            size: 22,
          ),
        ),
        title: Text(entry.workoutName,
            style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(
          '${AppDateUtils.relativeDay(entry.startTime)} • ${entry.exercises.length} exercises',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.grey500),
        ),
        trailing: Text(
          AppDateUtils.formatDuration(Duration(seconds: entry.durationSeconds)),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.exercisePurple,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
