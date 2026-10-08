import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/achievement.dart';
import '../../../shared/models/daily_activity.dart';
import '../../../shared/providers/services_providers.dart';
import '../../../shared/models/streak.dart';
import '../../auth/providers/auth_provider.dart';

final achievementsProvider = StreamProvider<List<Achievement>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ref.read(firestoreServiceProvider).achievementsStream(uid);
});

final achievementsNotifierProvider =
    StateNotifierProvider<AchievementsNotifier, AsyncValue<void>>(
        (ref) => AchievementsNotifier(ref));

class AchievementsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AchievementsNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<List<AchievementType>> checkAndUnlock({
    required DailyActivity todayActivity,
    required StreakData streak,
    required int totalWalks,
    required int totalWorkouts,
    required double totalDistanceKm,
  }) async {
    final uid = _ref.read(currentUserIdProvider);
    final existing =
        await _ref.read(firestoreServiceProvider).achievementsStream(uid).first;
    final unlockedTypes = existing
        .where((a) => a.isUnlocked)
        .map((a) => a.type)
        .toSet();

    final newlyUnlocked = <AchievementType>[];

    Future<void> tryUnlock(AchievementType type) async {
      if (!unlockedTypes.contains(type)) {
        newlyUnlocked.add(type);
        await _ref.read(firestoreServiceProvider).unlockAchievement(
              uid,
              Achievement(
                achievementId: type.name,
                type: type,
                isUnlocked: true,
                unlockedAt: DateTime.now(),
              ),
            );
      }
    }

    // Check each condition
    if (totalWalks >= 1) await tryUnlock(AchievementType.firstWalk);
    if (totalWorkouts >= 1) await tryUnlock(AchievementType.firstWorkout);
    if (todayActivity.steps >= 1000) await tryUnlock(AchievementType.steps1k);
    if (todayActivity.steps >= 5000) await tryUnlock(AchievementType.steps5k);
    if (todayActivity.steps >= 10000) await tryUnlock(AchievementType.steps10k);
    if (totalDistanceKm >= 10) await tryUnlock(AchievementType.distance10km);
    if (totalDistanceKm >= 50) await tryUnlock(AchievementType.distance50km);
    if (totalDistanceKm >= 100) await tryUnlock(AchievementType.distance100km);
    if (totalWorkouts >= 10) await tryUnlock(AchievementType.workouts10);
    if (totalWorkouts >= 50) await tryUnlock(AchievementType.workouts50);
    if (streak.currentStreak >= 7) await tryUnlock(AchievementType.streak7);
    if (streak.currentStreak >= 30) await tryUnlock(AchievementType.streak30);
    if (streak.currentStreak >= 100) await tryUnlock(AchievementType.streak100);
    if (totalWalks >= 10) await tryUnlock(AchievementType.walks10);
    if (totalWalks >= 50) await tryUnlock(AchievementType.walks50);
    if (totalWalks >= 100) await tryUnlock(AchievementType.walks100);

    return newlyUnlocked;
  }
}
