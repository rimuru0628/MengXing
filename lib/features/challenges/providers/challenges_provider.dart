import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/challenge.dart';
import '../../../shared/providers/services_providers.dart';
import '../../auth/providers/auth_provider.dart';

final challengesProvider = StreamProvider<List<Challenge>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ref.read(firestoreServiceProvider).challengesStream(uid);
});

final challengesNotifierProvider =
    StateNotifierProvider<ChallengesNotifier, AsyncValue<void>>(
        (ref) => ChallengesNotifier(ref));

class ChallengesNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ChallengesNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> initDefaultChallenges() async {
    final uid = _ref.read(currentUserIdProvider);
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));

    final defaults = [
      Challenge(
        challengeId: 'daily_steps_${now.toIso8601String().substring(0, 10)}',
        title: 'Daily Step Challenge',
        description: 'Walk 5,000 steps today',
        type: ChallengeType.daily,
        targetValue: 5000,
        unit: 'steps',
        startDate: now,
        endDate: endOfDay,
        emoji: '👟',
      ),
      Challenge(
        challengeId: 'weekly_distance_${now.toIso8601String().substring(0, 10)}',
        title: 'Weekly Distance',
        description: 'Walk 25 km this week',
        type: ChallengeType.weekly,
        targetValue: 25,
        unit: 'km',
        startDate: now,
        endDate: endOfWeek,
        emoji: '🗺️',
      ),
      Challenge(
        challengeId: 'weekly_workouts_${now.toIso8601String().substring(0, 10)}',
        title: 'Workout Challenge',
        description: 'Complete 5 workouts this week',
        type: ChallengeType.weekly,
        targetValue: 5,
        unit: 'workouts',
        startDate: now,
        endDate: endOfWeek,
        emoji: '💪',
      ),
    ];

    for (final challenge in defaults) {
      await _ref.read(firestoreServiceProvider).saveChallenge(uid, challenge);
    }
  }

  Future<void> updateProgress(String challengeId, double progress) async {
    final uid = _ref.read(currentUserIdProvider);
    final challenges =
        await _ref.read(firestoreServiceProvider).challengesStream(uid).first;
    final challenge = challenges.firstWhere(
      (c) => c.challengeId == challengeId,
      orElse: () => throw Exception('Challenge not found'),
    );
    final updated = challenge.copyWith(
      currentValue: progress,
      status: progress >= challenge.targetValue
          ? ChallengeStatus.completed
          : ChallengeStatus.inProgress,
    );
    await _ref.read(firestoreServiceProvider).saveChallenge(uid, updated);
  }
}
