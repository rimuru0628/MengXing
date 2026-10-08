import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/permissions_screen.dart';
import '../../features/profile/screens/profile_setup_screen.dart';
import '../../features/profile/screens/goals_setup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/walk/screens/walk_screen.dart';
import '../../features/walk/screens/walk_session_screen.dart';
import '../../features/walk/screens/walk_summary_screen.dart';
import '../../features/walk/screens/walk_history_screen.dart';
import '../../features/exercise/screens/exercise_screen.dart';
import '../../features/exercise/screens/exercise_library_screen.dart';
import '../../features/exercise/screens/exercise_detail_screen.dart';
import '../../features/exercise/screens/workout_player_screen.dart';
import '../../features/exercise/screens/workout_summary_screen.dart';
import '../../features/exercise/screens/workout_history_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/progress/screens/activity_calendar_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/achievements/screens/achievements_screen.dart';
import '../../features/challenges/screens/challenges_screen.dart';
import '../../features/ai_assistant/screens/ai_assistant_screen.dart';
import '../../shared/screens/splash_screen.dart';
import '../shell/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot') ||
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.onboarding;

      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (_, __) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.goalsSetup,
        builder: (_, __) => const GoalsSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.permissionsSetup,
        builder: (_, __) => const PermissionsScreen(),
      ),
      // Main shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.walk,
                builder: (_, __) => const WalkScreen(),
                routes: [
                  GoRoute(
                    path: 'session',
                    builder: (_, __) => const WalkSessionScreen(),
                  ),
                  GoRoute(
                    path: 'summary',
                    builder: (context, state) => WalkSummaryScreen(
                      sessionId: state.extra as String?,
                    ),
                  ),
                  GoRoute(
                    path: 'history',
                    builder: (_, __) => const WalkHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.exercise,
                builder: (_, __) => const ExerciseScreen(),
                routes: [
                  GoRoute(
                    path: 'library',
                    builder: (_, __) => const ExerciseLibraryScreen(),
                  ),
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) => ExerciseDetailScreen(
                      exerciseId: state.extra as String,
                    ),
                  ),
                  GoRoute(
                    path: 'player',
                    builder: (context, state) => WorkoutPlayerScreen(
                      workoutId: state.extra as String?,
                    ),
                  ),
                  GoRoute(
                    path: 'summary',
                    builder: (context, state) => WorkoutSummaryScreen(
                      historyId: state.extra as String?,
                    ),
                  ),
                  GoRoute(
                    path: 'history',
                    builder: (_, __) => const WorkoutHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (_, __) => const ProgressScreen(),
                routes: [
                  GoRoute(
                    path: 'calendar',
                    builder: (_, __) => const ActivityCalendarScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (_, __) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Modal routes (outside shell)
      GoRoute(
        path: AppRoutes.achievements,
        builder: (_, __) => const AchievementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.challenges,
        builder: (_, __) => const ChallengesScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiAssistant,
        builder: (_, __) => const AiAssistantScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
