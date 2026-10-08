import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/exercise.dart';
import '../../../core/l10n/locale_provider.dart';
import '../providers/exercise_provider.dart';

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState
    extends ConsumerState<ExerciseLibraryScreen> {
  ExerciseCategory? _selectedCategory;
  ExerciseDifficulty? _selectedDifficulty;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final all = ref.watch(exerciseCatalogProvider);
    final filtered = all.where((e) {
      if (_selectedCategory != null && e.category != _selectedCategory) {
        return false;
      }
      if (_selectedDifficulty != null && e.difficulty != _selectedDifficulty) {
        return false;
      }
      if (_search.isNotEmpty &&
          !e.name.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(s.exerciseLibrary)),
      body: Column(
        children: [
          // Search + filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: s.searchExercisesHint,
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: s.allFilter,
                        selected: _selectedCategory == null,
                        onTap: () =>
                            setState(() => _selectedCategory = null),
                      ),
                      ...ExerciseCategory.values.map((c) => _FilterChip(
                            label: _categoryName(c),
                            selected: _selectedCategory == c,
                            onTap: () =>
                                setState(() => _selectedCategory = c),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Exercise list
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(s.noExercisesFound))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) =>
                        _ExerciseTile(exercise: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  String _categoryName(ExerciseCategory c) {
    switch (c) {
      case ExerciseCategory.fullBody: return 'Full Body';
      case ExerciseCategory.chest: return 'Chest';
      case ExerciseCategory.back: return 'Back';
      case ExerciseCategory.shoulders: return 'Shoulders';
      case ExerciseCategory.arms: return 'Arms';
      case ExerciseCategory.legs: return 'Legs';
      case ExerciseCategory.core: return 'Core';
      case ExerciseCategory.cardio: return 'Cardio';
      case ExerciseCategory.walking: return 'Walking';
      case ExerciseCategory.running: return 'Running';
      case ExerciseCategory.stretching: return 'Stretching';
      case ExerciseCategory.recovery: return 'Recovery';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? AppColors.primary : null,
                fontWeight: selected ? FontWeight.w600 : null,
              ),
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  const _ExerciseTile({required this.exercise});

  Color get _diffColor {
    switch (exercise.difficulty) {
      case ExerciseDifficulty.beginner: return AppColors.difficultyBeginner;
      case ExerciseDifficulty.intermediate: return AppColors.difficultyIntermediate;
      case ExerciseDifficulty.advanced: return AppColors.difficultyAdvanced;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.exercisePurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.fitness_center_rounded,
              color: AppColors.exercisePurple, size: 24),
        ),
        title: Text(exercise.name,
            style: Theme.of(context).textTheme.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              exercise.muscleGroups.join(', '),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _diffColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                exercise.difficultyDisplayName,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _diffColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        onTap: () => context.push('/exercise/detail', extra: exercise.exerciseId),
      ),
    );
  }
}
