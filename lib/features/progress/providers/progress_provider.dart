import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/models/daily_activity.dart';
import '../../../shared/providers/services_providers.dart';
import '../../auth/providers/auth_provider.dart';
import '../../walk/providers/walk_provider.dart';

// Weekly activities
final weeklyActivitiesProvider =
    FutureProvider<List<DailyActivity>>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  final now = DateTime.now();
  final start = AppDateUtils.startOfWeek(now);
  return ref
      .read(firestoreServiceProvider)
      .getDailyActivitiesForRange(uid, start, now);
});

// Monthly activities
final monthlyActivitiesProvider =
    FutureProvider<List<DailyActivity>>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  final now = DateTime.now();
  final start = AppDateUtils.startOfMonth(now);
  return ref
      .read(firestoreServiceProvider)
      .getDailyActivitiesForRange(uid, start, now);
});

// Specific date range
final rangeActivitiesProvider =
    FutureProvider.family<List<DailyActivity>, DateRange>((ref, range) async {
  final uid = ref.watch(currentUserIdProvider);
  return ref
      .read(firestoreServiceProvider)
      .getDailyActivitiesForRange(uid, range.start, range.end);
});

// Weekly summary
class WeeklySummary {
  final int totalSteps;
  final double totalDistanceKm;
  final int totalWalks;
  final int totalActiveMinutes;
  final int workoutsCompleted;
  final double avgDailySteps;
  final List<DailyActivity> days;

  const WeeklySummary({
    required this.totalSteps,
    required this.totalDistanceKm,
    required this.totalWalks,
    required this.totalActiveMinutes,
    required this.workoutsCompleted,
    required this.avgDailySteps,
    required this.days,
  });

  factory WeeklySummary.fromActivities(List<DailyActivity> activities) {
    if (activities.isEmpty) {
      return const WeeklySummary(
        totalSteps: 0,
        totalDistanceKm: 0,
        totalWalks: 0,
        totalActiveMinutes: 0,
        workoutsCompleted: 0,
        avgDailySteps: 0,
        days: [],
      );
    }
    return WeeklySummary(
      totalSteps: activities.fold(0, (s, a) => s + a.steps),
      totalDistanceKm:
          activities.fold(0.0, (s, a) => s + a.distanceKm),
      totalWalks: activities.fold(0, (s, a) => s + a.walkCount),
      totalActiveMinutes:
          activities.fold(0, (s, a) => s + a.activeMinutes),
      workoutsCompleted:
          activities.where((a) => a.workoutCompleted).length,
      avgDailySteps:
          activities.fold(0, (s, a) => s + a.steps) / activities.length,
      days: activities,
    );
  }
}

final weeklySummaryProvider = FutureProvider<WeeklySummary>((ref) async {
  final activities = await ref.watch(weeklyActivitiesProvider.future);
  return WeeklySummary.fromActivities(activities);
});
