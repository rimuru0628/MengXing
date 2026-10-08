import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/models/exercise.dart';
import '../providers/exercise_provider.dart';

class WorkoutPlayerScreen extends ConsumerStatefulWidget {
  final String? workoutId;
  const WorkoutPlayerScreen({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends ConsumerState<WorkoutPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workout = ref.read(todayWorkoutProvider);
      ref.read(workoutPlayerProvider.notifier).loadWorkout(workout);
    });
  }

  Future<void> _finish() async {
    final entry = await ref.read(workoutPlayerProvider.notifier).saveWorkout();
    if (!mounted) return;
    context.pushReplacement('/exercise/summary', extra: entry?.historyId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutPlayerProvider);
    final s = ref.watch(stringsProvider);

    if (state.status == WorkoutPlayerState.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _finish());
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final ex = state.currentExercise;
    if (ex == null) {
      return const Scaffold(
        body: Center(child: Text('No exercises loaded')),
      );
    }

    final isResting = state.status == WorkoutPlayerState.resting;

    return Scaffold(
      backgroundColor:
          isResting ? AppColors.accent.withOpacity(0.05) : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isResting ? s.restLabel : ex.exercise.name),
        leading: BackButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Stop Workout?'),
                content: const Text('Your progress will be saved.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue')),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final entry = await ref
                          .read(workoutPlayerProvider.notifier)
                          .saveWorkout();
                      if (context.mounted) {
                        context.pushReplacement('/exercise/summary',
                            extra: entry?.historyId);
                      }
                    },
                    child: const Text('End & Save',
                        style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: state.progress,
              minHeight: 4,
              backgroundColor: AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.exercisePurple),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exercise ${state.currentIndex + 1} / ${state.exercises.length}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.grey500),
                  ),
                  Text(
                    AppDateUtils.formatDuration(
                        Duration(seconds: state.elapsedSeconds)),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            ),

            Expanded(
              child: isResting
                  ? _RestView(seconds: state.timerSeconds)
                  : _ExerciseView(
                      workoutExercise: ex,
                      currentSet: state.currentSet,
                      timerSeconds: state.timerSeconds,
                      nextExercise: state.nextExercise?.exercise.name,
                    ),
            ),

            // Controls
            _WorkoutControls(state: state),
          ],
        ),
      ),
    );
  }
}

class _ExerciseView extends ConsumerWidget {
  final WorkoutExercise workoutExercise;
  final int currentSet;
  final int timerSeconds;
  final String? nextExercise;

  const _ExerciseView({
    required this.workoutExercise,
    required this.currentSet,
    required this.timerSeconds,
    this.nextExercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final ex = workoutExercise.exercise;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Exercise illustration
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.exercisePurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fitness_center_rounded,
                color: AppColors.exercisePurple, size: 80),
          ),
          const SizedBox(height: 24),

          Text(
            ex.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            ex.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Set / reps
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SetChip(
                label: 'Set',
                value: '$currentSet / ${workoutExercise.sets}',
              ),
              const SizedBox(width: 16),
              ex.isTimeBased
                  ? _SetChip(
                      label: 'Time',
                      value: AppDateUtils.formatDurationMinutes(timerSeconds),
                    )
                  : _SetChip(
                      label: 'Reps',
                      value: '${workoutExercise.reps}',
                    ),
            ],
          ),

          const SizedBox(height: 24),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.howToLabel,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...ex.instructions.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${e.key + 1}. ',
                              style: TextStyle(
                                  color: AppColors.exercisePurple,
                                  fontWeight: FontWeight.w600)),
                          Expanded(
                              child: Text(e.value,
                                  style: Theme.of(context).textTheme.bodyMedium)),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          if (nextExercise != null) ...[
            const SizedBox(height: 16),
            Text(
              'Up next: $nextExercise',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.grey500),
            ),
          ],
        ],
      ),
    );
  }
}

class _RestView extends ConsumerWidget {
  final int seconds;
  const _RestView({required this.seconds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😮‍💨', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          Text(
            s.restLabel,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            AppDateUtils.formatDurationMinutes(seconds),
            style: AppTextStyles.statNumber(size: 64, color: AppColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            s.isChinese ? '秒后' : 'seconds remaining',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _SetChip extends StatelessWidget {
  final String label;
  final String value;
  const _SetChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.exercisePurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.statNumber(
                size: 28, color: AppColors.exercisePurple),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _WorkoutControls extends ConsumerWidget {
  final WorkoutState state;
  const _WorkoutControls({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final notifier = ref.read(workoutPlayerProvider.notifier);
    final isPaused = state.isPaused;
    final isResting = state.status == WorkoutPlayerState.resting;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Previous
          IconButton.outlined(
            onPressed: notifier.previous,
            icon: const Icon(Icons.skip_previous_rounded),
          ),
          const SizedBox(width: 8),
          // Pause / resume
          IconButton.outlined(
            onPressed: isPaused ? notifier.resume : notifier.pause,
            icon: Icon(
                isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
          ),
          const SizedBox(width: 8),
          // Main action
          Expanded(
            child: ElevatedButton(
              onPressed: isResting
                  ? null
                  : (state.currentExercise?.exercise.isTimeBased == true
                      ? null
                      : notifier.completeCurrentReps),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.exercisePurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                isResting
                    ? s.restingLabel
                    : state.currentExercise?.exercise.isTimeBased == true
                        ? s.timerRunningLabel
                        : s.doneBtn,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Skip
          IconButton.outlined(
            onPressed: notifier.skip,
            icon: const Icon(Icons.skip_next_rounded),
          ),
          const SizedBox(width: 8),
          // Finish
          IconButton.filled(
            onPressed: notifier.finish,
            icon: const Icon(Icons.stop_rounded),
            style: IconButton.styleFrom(backgroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }
}
