import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/widgets/app_button.dart';
import '../providers/exercise_provider.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(exerciseCatalogProvider);
    final exercise = catalog.firstWhere(
      (e) => e.exerciseId == exerciseId,
      orElse: () => catalog.first,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.exercisePurple, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.fitness_center_rounded,
                      color: Colors.white, size: 80),
                ),
              ),
              title: Text(exercise.name,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + difficulty chips
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(exercise.categoryDisplayName),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: const TextStyle(color: AppColors.primary),
                      ),
                      Chip(
                        label: Text(exercise.difficultyDisplayName),
                        backgroundColor: _diffColor(exercise.difficulty).withOpacity(0.1),
                        labelStyle: TextStyle(
                            color: _diffColor(exercise.difficulty)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(exercise.description,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),

                  // Muscle groups
                  if (exercise.muscleGroups.isNotEmpty) ...[
                    _SectionTitle('Target Muscles'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: exercise.muscleGroups
                          .map((m) => Chip(
                                label: Text(m),
                                labelStyle: const TextStyle(fontSize: 12),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Sets / reps / duration
                  _SectionTitle('Workout Details'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _DetailItem(label: 'Sets', value: '${exercise.defaultSets}'),
                      if (!exercise.isTimeBased)
                        _DetailItem(label: 'Reps', value: '${exercise.defaultReps}'),
                      if (exercise.isTimeBased)
                        _DetailItem(label: 'Duration', value: '${exercise.durationSeconds}s'),
                      _DetailItem(label: 'Rest', value: '${exercise.restSeconds}s'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Instructions
                  if (exercise.instructions.isNotEmpty) ...[
                    _SectionTitle('How to Perform'),
                    const SizedBox(height: 12),
                    ...exercise.instructions.asMap().entries.map((e) =>
                        _InstructionStep(step: e.key + 1, text: e.value)),
                  ],

                  const SizedBox(height: 24),

                  // Safety note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Stop immediately if you feel pain, dizziness, or unusual discomfort. Consult a professional if unsure.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.warning,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Start Workout',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => context.push('/exercise/player', extra: null),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _diffColor(ExerciseDifficulty d) {
    switch (d) {
      case ExerciseDifficulty.beginner: return AppColors.difficultyBeginner;
      case ExerciseDifficulty.intermediate: return AppColors.difficultyIntermediate;
      case ExerciseDifficulty.advanced: return AppColors.difficultyAdvanced;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleMedium);
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final int step;
  final String text;
  const _InstructionStep({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$step',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
