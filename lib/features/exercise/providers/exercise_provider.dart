import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/models/exercise.dart';
import '../../../shared/models/workout_history.dart';
import '../../../shared/providers/services_providers.dart';
import '../../auth/providers/auth_provider.dart';
import '../../home/providers/home_provider.dart';

// ─── Exercise catalog (seeded locally) ───────────────────────────────────────
final exerciseCatalogProvider = Provider<List<Exercise>>((ref) {
  return _builtinExercises;
});

final exercisesByCategoryProvider =
    Provider.family<List<Exercise>, ExerciseCategory>((ref, category) {
  return ref
      .watch(exerciseCatalogProvider)
      .where((e) => e.category == category)
      .toList();
});

// ─── Today's workout (generated from profile) ────────────────────────────────
final todayWorkoutProvider = Provider<List<WorkoutExercise>>((ref) {
  return _generateDefaultWorkout(ref.read(exerciseCatalogProvider));
});

List<WorkoutExercise> _generateDefaultWorkout(List<Exercise> catalog) {
  // Warm-up + main + cool-down
  final warmup = catalog
      .where((e) => e.category == ExerciseCategory.stretching)
      .take(2)
      .map((e) => WorkoutExercise(
            exercise: e,
            sets: 1,
            reps: 0,
            durationSeconds: 30,
            restSeconds: 15,
          ))
      .toList();

  final main = catalog
      .where((e) =>
          e.category == ExerciseCategory.fullBody ||
          e.category == ExerciseCategory.core)
      .take(5)
      .map((e) => WorkoutExercise(
            exercise: e,
            sets: e.defaultSets,
            reps: e.defaultReps,
            durationSeconds: e.durationSeconds,
            restSeconds: e.restSeconds,
          ))
      .toList();

  final cooldown = catalog
      .where((e) => e.category == ExerciseCategory.recovery)
      .take(2)
      .map((e) => WorkoutExercise(
            exercise: e,
            sets: 1,
            reps: 0,
            durationSeconds: 30,
            restSeconds: 10,
          ))
      .toList();

  return [...warmup, ...main, ...cooldown];
}

// ─── Workout Player ───────────────────────────────────────────────────────────
enum WorkoutPlayerState { idle, exercising, resting, finished }

class WorkoutState {
  final WorkoutPlayerState status;
  final List<WorkoutExercise> exercises;
  final int currentIndex;
  final int currentSet;
  final int timerSeconds;
  final int elapsedSeconds;
  final bool isPaused;

  const WorkoutState({
    this.status = WorkoutPlayerState.idle,
    this.exercises = const [],
    this.currentIndex = 0,
    this.currentSet = 1,
    this.timerSeconds = 0,
    this.elapsedSeconds = 0,
    this.isPaused = false,
  });

  WorkoutExercise? get currentExercise =>
      currentIndex < exercises.length ? exercises[currentIndex] : null;
  WorkoutExercise? get nextExercise =>
      currentIndex + 1 < exercises.length ? exercises[currentIndex + 1] : null;
  double get progress =>
      exercises.isEmpty ? 0 : currentIndex / exercises.length;

  WorkoutState copyWith({
    WorkoutPlayerState? status,
    List<WorkoutExercise>? exercises,
    int? currentIndex,
    int? currentSet,
    int? timerSeconds,
    int? elapsedSeconds,
    bool? isPaused,
  }) =>
      WorkoutState(
        status: status ?? this.status,
        exercises: exercises ?? this.exercises,
        currentIndex: currentIndex ?? this.currentIndex,
        currentSet: currentSet ?? this.currentSet,
        timerSeconds: timerSeconds ?? this.timerSeconds,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        isPaused: isPaused ?? this.isPaused,
      );
}

final workoutPlayerProvider =
    StateNotifierProvider<WorkoutPlayerNotifier, WorkoutState>(
        (ref) => WorkoutPlayerNotifier(ref));

class WorkoutPlayerNotifier extends StateNotifier<WorkoutState> {
  final Ref _ref;
  Timer? _exerciseTimer;
  Timer? _elapsedTimer;
  final _uuid = const Uuid();

  WorkoutPlayerNotifier(this._ref) : super(const WorkoutState());

  void loadWorkout(List<WorkoutExercise> exercises) {
    state = WorkoutState(
      exercises: exercises,
      status: WorkoutPlayerState.exercising,
      timerSeconds: exercises.first.durationSeconds ?? 0,
    );
    if (exercises.first.durationSeconds != null) {
      _startExerciseTimer(exercises.first.durationSeconds!);
    }
    _startElapsedTimer();
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
  }

  void _startExerciseTimer(int seconds) {
    _exerciseTimer?.cancel();
    state = state.copyWith(timerSeconds: seconds);
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused && state.timerSeconds > 0) {
        state = state.copyWith(timerSeconds: state.timerSeconds - 1);
        if (state.timerSeconds == 0) {
          _exerciseTimer?.cancel();
          _onExerciseTimerDone();
        }
      }
    });
  }

  void _onExerciseTimerDone() {
    if (state.status == WorkoutPlayerState.exercising) {
      // Move to rest
      final restSecs = state.currentExercise?.restSeconds ?? 60;
      state = state.copyWith(status: WorkoutPlayerState.resting);
      _startExerciseTimer(restSecs);
    } else if (state.status == WorkoutPlayerState.resting) {
      _advanceExercise();
    }
  }

  void _advanceExercise() {
    final ex = state.currentExercise;
    if (ex == null) return;

    // Mark current set done
    ex.completedSets++;

    if (ex.completedSets < ex.sets) {
      // Next set
      state = state.copyWith(
        currentSet: state.currentSet + 1,
        status: WorkoutPlayerState.exercising,
        timerSeconds: ex.durationSeconds ?? 0,
      );
      if (ex.durationSeconds != null) _startExerciseTimer(ex.durationSeconds!);
    } else {
      // Mark exercise complete, move to next
      ex.isCompleted = true;
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.exercises.length) {
        finish();
      } else {
        final next = state.exercises[nextIndex];
        state = state.copyWith(
          currentIndex: nextIndex,
          currentSet: 1,
          status: WorkoutPlayerState.exercising,
          timerSeconds: next.durationSeconds ?? 0,
        );
        if (next.durationSeconds != null) _startExerciseTimer(next.durationSeconds!);
      }
    }
  }

  void completeCurrentReps() => _advanceExercise();

  void skip() => _advanceExercise();

  void previous() {
    if (state.currentIndex > 0) {
      final prevIndex = state.currentIndex - 1;
      final prev = state.exercises[prevIndex];
      state = state.copyWith(
        currentIndex: prevIndex,
        currentSet: 1,
        status: WorkoutPlayerState.exercising,
        timerSeconds: prev.durationSeconds ?? 0,
      );
      if (prev.durationSeconds != null) _startExerciseTimer(prev.durationSeconds!);
    }
  }

  void pause() => state = state.copyWith(isPaused: true);
  void resume() => state = state.copyWith(isPaused: false);

  void finish() {
    _exerciseTimer?.cancel();
    _elapsedTimer?.cancel();
    state = state.copyWith(status: WorkoutPlayerState.finished);
  }

  Future<WorkoutHistoryEntry?> saveWorkout() async {
    final uid = _ref.read(currentUserIdProvider);
    final historyId = 'workout_${_uuid.v4()}';
    final now = DateTime.now();
    final exercises = state.exercises
        .map((we) => CompletedExercise(
              exerciseId: we.exercise.exerciseId,
              name: we.exercise.name,
              sets: we.sets,
              reps: we.reps,
              durationSeconds: we.durationSeconds,
              completed: we.isCompleted,
            ))
        .toList();

    final entry = WorkoutHistoryEntry(
      historyId: historyId,
      workoutName: 'Daily Workout',
      date: AppDateUtils.toDateKey(now),
      startTime: now.subtract(Duration(seconds: state.elapsedSeconds)),
      endTime: now,
      durationSeconds: state.elapsedSeconds,
      exercises: exercises,
      isCompleted: state.exercises.every((e) => e.isCompleted),
      calories: state.elapsedSeconds / 60.0 * 6.0, // ~6 kcal/min estimate
    );

    await _ref.read(firestoreServiceProvider).saveWorkoutHistory(uid, entry);
    await _ref.read(activitySyncProvider.notifier).markWorkoutCompleted();
    reset();
    return entry;
  }

  void reset() {
    _exerciseTimer?.cancel();
    _elapsedTimer?.cancel();
    state = const WorkoutState();
  }
}

// ─── Built-in exercise catalog ────────────────────────────────────────────────
final List<Exercise> _builtinExercises = [
  // Warm-up / Stretching
  Exercise(
    exerciseId: 'stretch_neck',
    name: 'Neck Rolls',
    description: 'Gently roll your head in circles to loosen neck muscles.',
    category: ExerciseCategory.stretching,
    muscleGroups: ['Neck'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Stand or sit tall', 'Slowly roll head clockwise 5 times', 'Repeat counter-clockwise'],
    defaultSets: 1,
    defaultReps: 0,
    durationSeconds: 30,
    restSeconds: 10,
  ),
  Exercise(
    exerciseId: 'stretch_shoulder',
    name: 'Arm Circles',
    description: 'Warm up your shoulder joints with arm circles.',
    category: ExerciseCategory.stretching,
    muscleGroups: ['Shoulders'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Extend arms to sides', 'Make small circles forward 10x', 'Reverse direction 10x'],
    defaultSets: 1,
    defaultReps: 0,
    durationSeconds: 30,
    restSeconds: 10,
  ),
  Exercise(
    exerciseId: 'stretch_hip',
    name: 'Hip Circles',
    description: 'Loosen hip flexors with circular movements.',
    category: ExerciseCategory.stretching,
    muscleGroups: ['Hips', 'Lower Back'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Feet shoulder-width apart, hands on hips', 'Circle hips clockwise 5x', 'Reverse 5x'],
    defaultSets: 1,
    defaultReps: 0,
    durationSeconds: 30,
    restSeconds: 10,
  ),
  // Core
  Exercise(
    exerciseId: 'plank',
    name: 'Plank',
    description: 'Hold a push-up position to build core strength.',
    category: ExerciseCategory.core,
    muscleGroups: ['Core', 'Shoulders', 'Glutes'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Start in push-up position', 'Keep body in a straight line', 'Hold position', 'Breathe steadily'],
    defaultSets: 3,
    defaultReps: 0,
    durationSeconds: 30,
    restSeconds: 60,
  ),
  Exercise(
    exerciseId: 'situp',
    name: 'Sit-ups',
    description: 'Classic abdominal exercise.',
    category: ExerciseCategory.core,
    muscleGroups: ['Core', 'Hip Flexors'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Lie on back, knees bent', 'Cross arms over chest', 'Curl upper body toward knees', 'Lower slowly'],
    defaultSets: 3,
    defaultReps: 15,
    restSeconds: 45,
  ),
  Exercise(
    exerciseId: 'mountain_climber',
    name: 'Mountain Climbers',
    description: 'Dynamic core exercise that also raises your heart rate.',
    category: ExerciseCategory.core,
    muscleGroups: ['Core', 'Shoulders', 'Legs'],
    difficulty: ExerciseDifficulty.intermediate,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Start in plank position', 'Drive right knee to chest', 'Switch legs rapidly', 'Keep hips level'],
    defaultSets: 3,
    defaultReps: 0,
    durationSeconds: 30,
    restSeconds: 45,
  ),
  // Full Body
  Exercise(
    exerciseId: 'squat',
    name: 'Squats',
    description: 'Compound lower body exercise targeting quads, glutes, and hamstrings.',
    category: ExerciseCategory.fullBody,
    muscleGroups: ['Quadriceps', 'Glutes', 'Hamstrings'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Feet shoulder-width apart', 'Push hips back and down', 'Keep chest up and knees over toes', 'Drive through heels to stand'],
    defaultSets: 3,
    defaultReps: 12,
    restSeconds: 60,
  ),
  Exercise(
    exerciseId: 'pushup',
    name: 'Push-ups',
    description: 'Upper body pushing exercise for chest, shoulders, and triceps.',
    category: ExerciseCategory.chest,
    muscleGroups: ['Chest', 'Shoulders', 'Triceps'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Place hands slightly wider than shoulder-width', 'Keep body straight from head to heels', 'Lower chest to floor', 'Push back up'],
    defaultSets: 3,
    defaultReps: 10,
    restSeconds: 60,
  ),
  Exercise(
    exerciseId: 'lunge',
    name: 'Lunges',
    description: 'Single-leg exercise for balance and leg strength.',
    category: ExerciseCategory.legs,
    muscleGroups: ['Quadriceps', 'Glutes', 'Hamstrings'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Stand tall, step forward with right foot', 'Lower back knee toward floor', 'Push off front foot to return', 'Alternate sides'],
    defaultSets: 3,
    defaultReps: 10,
    restSeconds: 60,
  ),
  Exercise(
    exerciseId: 'jumping_jacks',
    name: 'Jumping Jacks',
    description: 'Classic cardio exercise to elevate heart rate.',
    category: ExerciseCategory.cardio,
    muscleGroups: ['Full Body'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Stand with feet together', 'Jump feet out while raising arms', 'Jump feet back together while lowering arms', 'Repeat at a steady pace'],
    defaultSets: 3,
    defaultReps: 0,
    durationSeconds: 30,
    restSeconds: 45,
  ),
  Exercise(
    exerciseId: 'burpee',
    name: 'Burpees',
    description: 'Full-body high-intensity exercise.',
    category: ExerciseCategory.fullBody,
    muscleGroups: ['Full Body'],
    difficulty: ExerciseDifficulty.intermediate,
    equipment: [ExerciseEquipment.none],
    instructions: ['Stand, then drop hands to floor', 'Jump feet back to plank', 'Perform a push-up', 'Jump feet to hands', 'Jump up and clap overhead'],
    defaultSets: 3,
    defaultReps: 8,
    restSeconds: 90,
  ),
  Exercise(
    exerciseId: 'glute_bridge',
    name: 'Glute Bridges',
    description: 'Hip hinge movement to strengthen glutes and lower back.',
    category: ExerciseCategory.legs,
    muscleGroups: ['Glutes', 'Hamstrings', 'Lower Back'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Lie on back, knees bent, feet flat', 'Press feet into floor and lift hips', 'Squeeze glutes at top', 'Lower slowly'],
    defaultSets: 3,
    defaultReps: 15,
    restSeconds: 45,
  ),
  // Cool-down / Recovery
  Exercise(
    exerciseId: 'child_pose',
    name: 'Child\'s Pose',
    description: 'Resting stretch for back, hips, and thighs.',
    category: ExerciseCategory.recovery,
    muscleGroups: ['Back', 'Hips', 'Thighs'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Kneel on floor', 'Sit back on heels', 'Stretch arms forward on floor', 'Hold and breathe deeply'],
    defaultSets: 1,
    defaultReps: 0,
    durationSeconds: 45,
    restSeconds: 10,
  ),
  Exercise(
    exerciseId: 'cat_cow',
    name: 'Cat-Cow Stretch',
    description: 'Spinal mobility exercise for the back.',
    category: ExerciseCategory.recovery,
    muscleGroups: ['Spine', 'Core'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Start on hands and knees', 'Inhale, arch back downward (cow)', 'Exhale, round back upward (cat)', 'Flow between positions slowly'],
    defaultSets: 1,
    defaultReps: 0,
    durationSeconds: 45,
    restSeconds: 10,
  ),
  Exercise(
    exerciseId: 'quad_stretch',
    name: 'Standing Quad Stretch',
    description: 'Standing stretch for the quadriceps.',
    category: ExerciseCategory.recovery,
    muscleGroups: ['Quadriceps'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.none],
    instructions: ['Stand on one foot', 'Pull other foot toward glutes', 'Hold for 20 seconds', 'Switch sides'],
    defaultSets: 1,
    defaultReps: 0,
    durationSeconds: 40,
    restSeconds: 10,
  ),
  // Back
  Exercise(
    exerciseId: 'superman',
    name: 'Superman',
    description: 'Back extension exercise for lower back strength.',
    category: ExerciseCategory.back,
    muscleGroups: ['Lower Back', 'Glutes'],
    difficulty: ExerciseDifficulty.beginner,
    equipment: [ExerciseEquipment.mat],
    instructions: ['Lie face down', 'Simultaneously lift arms and legs off floor', 'Hold for 2 seconds', 'Lower slowly'],
    defaultSets: 3,
    defaultReps: 10,
    restSeconds: 45,
  ),
  // Shoulders
  Exercise(
    exerciseId: 'shoulder_press',
    name: 'Shoulder Press',
    description: 'Overhead pressing movement for shoulder strength.',
    category: ExerciseCategory.shoulders,
    muscleGroups: ['Deltoids', 'Triceps', 'Upper Trapezius'],
    difficulty: ExerciseDifficulty.intermediate,
    equipment: [ExerciseEquipment.dumbbell],
    instructions: ['Hold dumbbells at shoulder height', 'Press overhead until arms extend', 'Lower controlled', 'Keep core engaged'],
    defaultSets: 3,
    defaultReps: 10,
    restSeconds: 60,
  ),
];
