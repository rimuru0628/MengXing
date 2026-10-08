// App-wide constants for MengXing (梦行)

class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'MengXing';
  static const String appNameChinese = '梦行';
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String profileDoc = 'profile';
  static const String settingsDoc = 'settings';
  static const String goalsDoc = 'goals';
  static const String dailyActivityCollection = 'daily_activity';
  static const String walkingSessionsCollection = 'walking_sessions';
  static const String workoutHistoryCollection = 'workout_history';
  static const String achievementsCollection = 'achievements';
  static const String challengesCollection = 'challenges';
  static const String notificationsCollection = 'notifications';
  static const String exercisesCollection = 'exercises';

  // SharedPreferences keys
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyThemeMode = 'theme_mode';
  static const String keyUnits = 'units';
  static const String keyLastSyncDate = 'last_sync_date';
  static const String keyPendingSteps = 'pending_steps';
  static const String keyPendingDistance = 'pending_distance';
  static const String keyPendingActiveMinutes = 'pending_active_minutes';

  // Hive box names
  static const String hiveBoxWalkingSessions = 'walking_sessions_local';
  static const String hiveBoxDailyActivity = 'daily_activity_local';
  static const String hiveBoxWorkouts = 'workouts_local';
  static const String hiveBoxExercises = 'exercises_local';

  // Default goals
  static const int defaultDailySteps = 8000;
  static const double defaultDailyDistanceKm = 5.0;
  static const int defaultDailyActiveMinutes = 30;
  static const int defaultDailyWalks = 3;

  // Calorie estimation constants
  static const double caloriesPerStep = 0.04; // avg kcal per step
  static const double metWalking = 3.5; // MET value for moderate walking

  // Pace thresholds (min/km)
  static const double paceFastKm = 6.0;
  static const double paceModerateKm = 8.0;
  static const double paceSlowKm = 12.0;

  // Step length estimation (meters)
  static const double defaultStepLengthM = 0.762;

  // Animation durations
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 600);

  // Image placeholder
  static const String placeholderAvatar = 'assets/images/avatar_placeholder.png';
  static const String placeholderExercise = 'assets/images/exercise_placeholder.png';

  // Exercise rest time defaults (seconds)
  static const int defaultRestSeconds = 60;
  static const int shortRestSeconds = 30;
  static const int longRestSeconds = 90;

  // Streak
  static const int streakGracePeriodHours = 2; // grace window after midnight

  // AI
  static const int aiMaxHistoryMessages = 20;
  static const String aiSystemPrompt =
      'You are a friendly fitness assistant for MengXing, a walking and exercise tracking app. '
      'Give practical, motivating, and safe fitness advice. '
      'Do NOT provide medical diagnoses or replace professional medical advice. '
      'Keep responses concise and actionable. '
      'Base recommendations on the user\'s activity data when provided.';
}

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profileSetup = '/profile-setup';
  static const String goalsSetup = '/goals-setup';
  static const String permissionsSetup = '/permissions-setup';
  static const String shell = '/shell';
  static const String home = '/home';
  static const String walk = '/walk';
  static const String walkSession = '/walk/session';
  static const String walkSummary = '/walk/summary';
  static const String walkHistory = '/walk/history';
  static const String exercise = '/exercise';
  static const String exerciseLibrary = '/exercise/library';
  static const String exerciseDetail = '/exercise/detail';
  static const String workoutPlayer = '/exercise/player';
  static const String workoutSummary = '/exercise/summary';
  static const String workoutHistory = '/exercise/history';
  static const String progress = '/progress';
  static const String calendar = '/progress/calendar';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String achievements = '/achievements';
  static const String challenges = '/challenges';
  static const String aiAssistant = '/ai-assistant';
  static const String notifications = '/notifications';
}
