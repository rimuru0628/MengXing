import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/daily_activity.dart';
import '../../../shared/models/streak.dart';
import '../../../shared/providers/services_providers.dart';
import '../../auth/providers/auth_provider.dart';

// Today's activity (realtime)
final todayActivityProvider = StreamProvider<DailyActivity?>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ref.watch(firestoreServiceProvider).dailyActivityStream(uid, DateTime.now());
});

// Streak data
final streakProvider = FutureProvider<StreakData?>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  return ref.read(firestoreServiceProvider).getStreak(uid);
});

// Activity syncer — merges health data with Firestore
final activitySyncProvider =
    StateNotifierProvider<ActivitySyncNotifier, AsyncValue<DailyActivity>>(
        (ref) => ActivitySyncNotifier(ref));

class ActivitySyncNotifier
    extends StateNotifier<AsyncValue<DailyActivity>> {
  final Ref _ref;

  ActivitySyncNotifier(this._ref)
      : super(AsyncValue.data(DailyActivity.empty(DateTime.now())));

  Future<void> syncFromHealth() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final uid = _ref.read(currentUserIdProvider);
      final health = _ref.read(healthServiceProvider);
      final firestore = _ref.read(firestoreServiceProvider);

      // Try to get health data
      DailyActivity activity;
      try {
        final healthData = await health.getTodayHealthData();
        final existing = await firestore.getDailyActivity(uid, DateTime.now()) ??
            DailyActivity.empty(DateTime.now());
        // Use the higher value between health API and stored
        activity = existing.copyWith(
          steps: healthData.steps > existing.steps
              ? healthData.steps
              : existing.steps,
          distanceKm: healthData.distanceKm > existing.distanceKm
              ? healthData.distanceKm
              : existing.distanceKm,
          activeMinutes: healthData.activeMinutes > existing.activeMinutes
              ? healthData.activeMinutes
              : existing.activeMinutes,
          calories: healthData.calories > existing.calories
              ? healthData.calories
              : existing.calories,
        );
      } catch (_) {
        activity = await firestore.getDailyActivity(uid, DateTime.now()) ??
            DailyActivity.empty(DateTime.now());
      }

      await firestore.updateDailyActivity(uid, activity);
      return activity;
    });
  }

  Future<void> incrementWalkCount() async {
    final uid = _ref.read(currentUserIdProvider);
    final firestore = _ref.read(firestoreServiceProvider);
    final current = await firestore.getDailyActivity(uid, DateTime.now()) ??
        DailyActivity.empty(DateTime.now());
    await firestore.updateDailyActivity(
      uid,
      current.copyWith(walkCount: current.walkCount + 1),
    );
  }

  Future<void> markWorkoutCompleted() async {
    final uid = _ref.read(currentUserIdProvider);
    final firestore = _ref.read(firestoreServiceProvider);
    final current = await firestore.getDailyActivity(uid, DateTime.now()) ??
        DailyActivity.empty(DateTime.now());
    await firestore.updateDailyActivity(
      uid,
      current.copyWith(
        workoutCompleted: true,
        workoutCount: current.workoutCount + 1,
      ),
    );
  }
}
