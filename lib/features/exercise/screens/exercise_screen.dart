import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../providers/exercise_provider.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../home/providers/home_provider.dart';

class ExerciseScreen extends ConsumerWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayActivity = ref.watch(todayActivityProvider).valueOrNull;
    final workout = ref.watch(todayWorkoutProvider);
    final completed = todayActivity?.workoutCompleted ?? false;
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: Text(s.exerciseTitle,
                    style: TextStyle(
                        color: KColors.textPrimary,
                        fontWeight: FontWeight.w800)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.history_rounded,
                        color: KColors.accent),
                    onPressed: () => context.push('/exercise/history'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Workout hero
                      _WorkoutHero(
                          workout: workout, completed: completed),
                      const SizedBox(height: 24),

                      KuroSectionHeader(
                        title: s.exerciseCategoriesTitle,
                        action: s.browseAllBtn,
                        onAction: () =>
                            context.push('/exercise/library'),
                      ),
                      const SizedBox(height: 14),
                      _CategoryGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutHero extends ConsumerWidget {
  final List<WorkoutExercise> workout;
  final bool completed;
  const _WorkoutHero(
      {required this.workout, required this.completed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final warmups = workout
        .where((e) =>
            e.exercise.category == ExerciseCategory.stretching)
        .length;
    final main = workout
        .where((e) =>
            e.exercise.category != ExerciseCategory.stretching &&
            e.exercise.category != ExerciseCategory.recovery)
        .length;
    final cooldown = workout
        .where((e) =>
            e.exercise.category == ExerciseCategory.recovery)
        .length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: completed
              ? [const Color(0xFF0A3A2A), const Color(0xFF1A0A2E)]
              : [const Color(0xFF2A0E52), const Color(0xFF1A0A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (completed ? KColors.progressColor : KColors.primary)
              .withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: (completed ? KColors.progressColor : KColors.primary)
                .withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(completed ? '✅' : '💪',
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completed
                          ? s.workoutCompletedTitle
                          : s.todayWorkoutTitle2,
                      style: TextStyle(
                        color: completed
                            ? KColors.progressColor
                            : KColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${workout.length} ${s.exercisesCount} · ${s.approx30Min}',
                      style: const TextStyle(
                          color: KColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Section chips
          Row(
            children: [
              _SectionChip(s.warmupLabel, warmups),
              const SizedBox(width: 8),
              _SectionChip(s.mainLabel, main),
              const SizedBox(width: 8),
              _SectionChip(s.cooldownLabel, cooldown),
            ],
          ),
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: completed
                      ? [KColors.progressColor, KColors.walkColor]
                      : [KColors.primary, KColors.accent],
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: (completed
                            ? KColors.progressColor
                            : KColors.primary)
                        .withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.push('/exercise/player', extra: null),
                icon: Icon(
                    completed
                        ? Icons.replay_rounded
                        : Icons.play_arrow_rounded,
                    color: KColors.bg),
                label: Text(
                  completed ? s.doItAgainBtn : s.startWorkoutBtn,
                  style: const TextStyle(
                      color: KColors.bg,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  final String label;
  final int count;
  const _SectionChip(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: KColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text('$count',
                style: const TextStyle(
                    color: KColors.neonPurple,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            Text(label,
                style: const TextStyle(
                    color: KColors.textSecondary, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final cats = [
      ('🏋️', s.fullBodyCat),
      ('🧘', s.coreCat),
      ('🦵', s.legsCat),
      ('💪', s.chestCat),
      ('🔙', s.backCat),
      ('🏃', s.cardioCat),
      ('🤸', s.stretchingCat),
      ('😌', s.recoveryCat),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: cats
          .map((c) => GestureDetector(
                onTap: () => context.push('/exercise/library'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: KColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: KColors.border.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Text(c.$1,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(c.$2,
                          style: const TextStyle(
                              color: KColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
