// Firebase project constants
// Replace these with your actual Firebase project values after running `flutterfire configure`

class FirebaseConstants {
  FirebaseConstants._();

  // These will be injected via google-services.json / GoogleService-Info.plist
  // The values below are placeholders — replace after Firebase project setup

  // Storage paths
  static const String storageAvatars = 'avatars';
  static const String storageExerciseImages = 'exercises/images';
  static const String storageExerciseVideos = 'exercises/videos';
  static const String storageRoutes = 'routes';

  // FCM topics
  static const String fcmTopicAll = 'all_users';
  static const String fcmTopicDailyReminder = 'daily_reminder';
  static const String fcmTopicChallenges = 'challenges';

  // Cloud Functions
  static const String fnGenerateWorkout = 'generateDailyWorkout';
  static const String fnCalculateStreak = 'calculateStreak';
  static const String fnSendActivitySummary = 'sendDailyActivitySummary';
  static const String fnUnlockAchievement = 'checkAndUnlockAchievements';
}
