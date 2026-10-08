import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../shared/models/daily_activity.dart';
import '../../shared/models/user_profile.dart';
import '../../shared/models/walking_session.dart';
import '../../shared/models/workout_history.dart';
import '../../shared/models/achievement.dart';
import '../../shared/models/challenge.dart';
import '../../shared/models/streak.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── User collection reference ───────────────────────────────────
  DocumentReference _userDoc(String uid) =>
      _db.collection(AppConstants.usersCollection).doc(uid);

  CollectionReference _dailyActivity(String uid) =>
      _userDoc(uid).collection(AppConstants.dailyActivityCollection);

  CollectionReference _walkingSessions(String uid) =>
      _userDoc(uid).collection(AppConstants.walkingSessionsCollection);

  CollectionReference _workoutHistory(String uid) =>
      _userDoc(uid).collection(AppConstants.workoutHistoryCollection);

  CollectionReference _achievements(String uid) =>
      _userDoc(uid).collection(AppConstants.achievementsCollection);

  CollectionReference _challenges(String uid) =>
      _userDoc(uid).collection(AppConstants.challengesCollection);

  // ─── Profile ─────────────────────────────────────────────────────
  Future<void> createProfile(String uid, UserProfile profile) =>
      _userDoc(uid)
          .collection('profile')
          .doc('data')
          .set(profile.toFirestore());

  Future<UserProfile?> getProfile(String uid) async {
    final snap = await _userDoc(uid).collection('profile').doc('data').get();
    if (!snap.exists) return null;
    return UserProfile.fromFirestore(snap);
  }

  Stream<UserProfile?> profileStream(String uid) => _userDoc(uid)
      .collection('profile')
      .doc('data')
      .snapshots()
      .map((s) => s.exists ? UserProfile.fromFirestore(s) : null);

  Future<void> updateProfile(String uid, Map<String, dynamic> data) =>
      _userDoc(uid).collection('profile').doc('data').update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ─── Daily Activity ───────────────────────────────────────────────
  Future<DailyActivity?> getDailyActivity(String uid, DateTime date) async {
    final key = AppDateUtils.toDateKey(date);
    final snap = await _dailyActivity(uid).doc(key).get();
    if (!snap.exists) return null;
    return DailyActivity.fromFirestore(snap);
  }

  Stream<DailyActivity?> dailyActivityStream(String uid, DateTime date) {
    final key = AppDateUtils.toDateKey(date);
    return _dailyActivity(uid)
        .doc(key)
        .snapshots()
        .map((s) => s.exists ? DailyActivity.fromFirestore(s) : null);
  }

  Future<void> updateDailyActivity(
      String uid, DailyActivity activity) async {
    await _dailyActivity(uid)
        .doc(activity.date)
        .set(activity.toFirestore(), SetOptions(merge: true));
  }

  Future<List<DailyActivity>> getDailyActivitiesForRange(
      String uid, DateTime start, DateTime end) async {
    final startKey = AppDateUtils.toDateKey(start);
    final endKey = AppDateUtils.toDateKey(end);
    final snap = await _dailyActivity(uid)
        .where('date', isGreaterThanOrEqualTo: startKey)
        .where('date', isLessThanOrEqualTo: endKey)
        .orderBy('date')
        .get();
    return snap.docs.map((d) => DailyActivity.fromFirestore(d)).toList();
  }

  // ─── Walking Sessions ─────────────────────────────────────────────
  Future<void> saveWalkingSession(String uid, WalkingSession session) =>
      _walkingSessions(uid).doc(session.walkId).set(session.toFirestore());

  Future<List<WalkingSession>> getWalkingSessionsForDate(
      String uid, DateTime date) async {
    final key = AppDateUtils.toDateKey(date);
    final snap = await _walkingSessions(uid)
        .where('date', isEqualTo: key)
        .orderBy('startTime')
        .get();
    return snap.docs.map((d) => WalkingSession.fromFirestore(d)).toList();
  }

  Future<List<WalkingSession>> getWalkingSessionsForRange(
      String uid, DateTime start, DateTime end) async {
    final startKey = AppDateUtils.toDateKey(start);
    final endKey = AppDateUtils.toDateKey(end);
    final snap = await _walkingSessions(uid)
        .where('date', isGreaterThanOrEqualTo: startKey)
        .where('date', isLessThanOrEqualTo: endKey)
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map((d) => WalkingSession.fromFirestore(d)).toList();
  }

  // ─── Workout History ──────────────────────────────────────────────
  Future<void> saveWorkoutHistory(String uid, WorkoutHistoryEntry entry) =>
      _workoutHistory(uid).doc(entry.historyId).set(entry.toFirestore());

  Future<List<WorkoutHistoryEntry>> getWorkoutHistoryForRange(
      String uid, DateTime start, DateTime end) async {
    final startKey = AppDateUtils.toDateKey(start);
    final endKey = AppDateUtils.toDateKey(end);
    final snap = await _workoutHistory(uid)
        .where('date', isGreaterThanOrEqualTo: startKey)
        .where('date', isLessThanOrEqualTo: endKey)
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map((d) => WorkoutHistoryEntry.fromFirestore(d)).toList();
  }

  // ─── Achievements ─────────────────────────────────────────────────
  Future<void> unlockAchievement(String uid, Achievement achievement) =>
      _achievements(uid)
          .doc(achievement.achievementId)
          .set(achievement.toFirestore(), SetOptions(merge: true));

  Stream<List<Achievement>> achievementsStream(String uid) =>
      _achievements(uid).snapshots().map((snap) =>
          snap.docs.map((d) => Achievement.fromFirestore(d)).toList());

  // ─── Challenges ───────────────────────────────────────────────────
  Future<void> saveChallenge(String uid, Challenge challenge) =>
      _challenges(uid).doc(challenge.challengeId).set(challenge.toFirestore());

  Stream<List<Challenge>> challengesStream(String uid) =>
      _challenges(uid)
          .orderBy('endDate')
          .snapshots()
          .map((s) => s.docs.map((d) => Challenge.fromFirestore(d)).toList());

  // ─── Streak ───────────────────────────────────────────────────────
  Future<StreakData?> getStreak(String uid) async {
    final snap = await _userDoc(uid).collection('streak').doc('data').get();
    if (!snap.exists) return null;
    return StreakData.fromFirestore(snap.data()!);
  }

  Future<void> updateStreak(String uid, StreakData streak) =>
      _userDoc(uid)
          .collection('streak')
          .doc('data')
          .set(streak.toFirestore(), SetOptions(merge: true));

  // ─── Settings ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getSettings(String uid) async {
    final snap =
        await _userDoc(uid).collection('settings').doc('data').get();
    if (!snap.exists) return null;
    return snap.data();
  }

  Future<void> updateSettings(String uid, Map<String, dynamic> data) =>
      _userDoc(uid)
          .collection('settings')
          .doc('data')
          .set(data, SetOptions(merge: true));

  // ─── Delete user data ─────────────────────────────────────────────
  Future<void> deleteUserData(String uid) async {
    // Sub-collections must be deleted client-side or via Cloud Functions
    await _userDoc(uid).delete();
  }
}
