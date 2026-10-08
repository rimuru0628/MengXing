import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/date_utils.dart';

class DailyActivity {
  final String date; // yyyy-MM-dd
  final int steps;
  final double distanceKm;
  final int activeMinutes;
  final double calories;
  final int walkCount;
  final int workoutCount;
  final bool workoutCompleted;
  final bool goalCompleted;
  final DateTime? lastUpdated;

  const DailyActivity({
    required this.date,
    this.steps = 0,
    this.distanceKm = 0.0,
    this.activeMinutes = 0,
    this.calories = 0.0,
    this.walkCount = 0,
    this.workoutCount = 0,
    this.workoutCompleted = false,
    this.goalCompleted = false,
    this.lastUpdated,
  });

  factory DailyActivity.empty(DateTime date) => DailyActivity(
        date: AppDateUtils.toDateKey(date),
        lastUpdated: date,
      );

  factory DailyActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyActivity(
      date: data['date'] ?? doc.id,
      steps: data['steps'] ?? 0,
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0.0,
      activeMinutes: data['activeMinutes'] ?? 0,
      calories: (data['calories'] as num?)?.toDouble() ?? 0.0,
      walkCount: data['walkCount'] ?? 0,
      workoutCount: data['workoutCount'] ?? 0,
      workoutCompleted: data['workoutCompleted'] ?? false,
      goalCompleted: data['goalCompleted'] ?? false,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  factory DailyActivity.fromMap(Map<String, dynamic> data) => DailyActivity(
        date: data['date'] ?? '',
        steps: data['steps'] ?? 0,
        distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0.0,
        activeMinutes: data['activeMinutes'] ?? 0,
        calories: (data['calories'] as num?)?.toDouble() ?? 0.0,
        walkCount: data['walkCount'] ?? 0,
        workoutCount: data['workoutCount'] ?? 0,
        workoutCompleted: data['workoutCompleted'] ?? false,
        goalCompleted: data['goalCompleted'] ?? false,
      );

  Map<String, dynamic> toFirestore() => {
        'date': date,
        'steps': steps,
        'distanceKm': distanceKm,
        'activeMinutes': activeMinutes,
        'calories': calories,
        'walkCount': walkCount,
        'workoutCount': workoutCount,
        'workoutCompleted': workoutCompleted,
        'goalCompleted': goalCompleted,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toMap() => {
        'date': date,
        'steps': steps,
        'distanceKm': distanceKm,
        'activeMinutes': activeMinutes,
        'calories': calories,
        'walkCount': walkCount,
        'workoutCount': workoutCount,
        'workoutCompleted': workoutCompleted,
        'goalCompleted': goalCompleted,
      };

  DailyActivity copyWith({
    int? steps,
    double? distanceKm,
    int? activeMinutes,
    double? calories,
    int? walkCount,
    int? workoutCount,
    bool? workoutCompleted,
    bool? goalCompleted,
  }) =>
      DailyActivity(
        date: date,
        steps: steps ?? this.steps,
        distanceKm: distanceKm ?? this.distanceKm,
        activeMinutes: activeMinutes ?? this.activeMinutes,
        calories: calories ?? this.calories,
        walkCount: walkCount ?? this.walkCount,
        workoutCount: workoutCount ?? this.workoutCount,
        workoutCompleted: workoutCompleted ?? this.workoutCompleted,
        goalCompleted: goalCompleted ?? this.goalCompleted,
        lastUpdated: DateTime.now(),
      );

  double goalProgress({
    required int stepGoal,
    required double distanceGoal,
    required int activeMinuteGoal,
    required int walkGoal,
  }) {
    double score = 0;
    if (stepGoal > 0) score += (steps / stepGoal).clamp(0.0, 1.0);
    if (distanceGoal > 0) score += (distanceKm / distanceGoal).clamp(0.0, 1.0);
    if (activeMinuteGoal > 0) score += (activeMinutes / activeMinuteGoal).clamp(0.0, 1.0);
    if (walkGoal > 0) score += (walkCount / walkGoal).clamp(0.0, 1.0);
    return score / 4.0;
  }
}
