import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutHistoryEntry {
  final String historyId;
  final String workoutName;
  final String date; // yyyy-MM-dd
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final List<CompletedExercise> exercises;
  final bool isCompleted;
  final double calories;

  const WorkoutHistoryEntry({
    required this.historyId,
    required this.workoutName,
    required this.date,
    required this.startTime,
    this.endTime,
    this.durationSeconds = 0,
    this.exercises = const [],
    this.isCompleted = false,
    this.calories = 0.0,
  });

  factory WorkoutHistoryEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutHistoryEntry(
      historyId: doc.id,
      workoutName: data['workoutName'] ?? '',
      date: data['date'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      durationSeconds: data['durationSeconds'] ?? 0,
      exercises: (data['exercises'] as List? ?? [])
          .map((e) => CompletedExercise.fromMap(e as Map<String, dynamic>))
          .toList(),
      isCompleted: data['isCompleted'] ?? false,
      calories: (data['calories'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'workoutName': workoutName,
        'date': date,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
        'durationSeconds': durationSeconds,
        'exercises': exercises.map((e) => e.toMap()).toList(),
        'isCompleted': isCompleted,
        'calories': calories,
      };
}

class CompletedExercise {
  final String exerciseId;
  final String name;
  final int sets;
  final int reps;
  final int? durationSeconds;
  final bool completed;

  const CompletedExercise({
    required this.exerciseId,
    required this.name,
    required this.sets,
    required this.reps,
    this.durationSeconds,
    this.completed = false,
  });

  factory CompletedExercise.fromMap(Map<String, dynamic> map) =>
      CompletedExercise(
        exerciseId: map['exerciseId'] ?? '',
        name: map['name'] ?? '',
        sets: map['sets'] ?? 0,
        reps: map['reps'] ?? 0,
        durationSeconds: map['durationSeconds'],
        completed: map['completed'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'exerciseId': exerciseId,
        'name': name,
        'sets': sets,
        'reps': reps,
        'durationSeconds': durationSeconds,
        'completed': completed,
      };
}
