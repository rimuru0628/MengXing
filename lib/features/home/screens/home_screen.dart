import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/daily_activity.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../../shared/widgets/language_toggle.dart';
import '../../../shared/widgets/lottie_widget.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/streak_banner.dart';
import '../widgets/today_walks_summary.dart';
import '../widgets/today_workout_card.dart';
import '../widgets/goal_list_card.dart';
import '../../../shared/widgets/kuromi_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activitySyncProvider.notifier).syncFromHealth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).valueOrNull;
    final activityAsync = ref.watch(todayActivityProvider);
    final streakAsync = ref.watch(streakProvider);
    final firstName = profile?.name.split(' ').first ?? 'there';
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: RefreshIndicator(
            color: KColors.primary,
            backgroundColor: KColors.card,
            onRefresh: () =>
                ref.read(activitySyncProvider.notifier).syncFromHealth(),
            child: CustomScrollView(
              slivers: [
                // ── App bar ─────────────────────────────────────────────
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  titleSpacing: 16,
                  title: Row(
                    children: [
                      // Kuromi fitness icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: KColors.primary.withOpacity(0.4)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.asset(
                            'assets/images/kuromi_fitness.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey, $firstName 🖤',
                            style: const TextStyle(
                              color: KColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            AppDateUtils.formatDate(DateTime.now()),
                            style: const TextStyle(
                              color: KColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    const LanguageToggle(compact: true),
                    IconButton(
                      icon: const Icon(Icons.smart_toy_outlined,
                          color: KColors.accent),
                      onPressed: () => context.push(AppRoutes.aiAssistant),
                      tooltip: 'AI',
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: KColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: activityAsync.when(
                    loading: () => const _HomeLoader(),
                    error: (_, __) => const _HomeError(),
                    data: (activity) {
                      final act =
                          activity ?? DailyActivity.empty(DateTime.now());
                      final stepGoal = profile?.dailyStepGoal ??
                          AppConstants.defaultDailySteps;
                      final distGoal = profile?.dailyWalkingGoalKm ??
                          AppConstants.defaultDailyDistanceKm;
                      final activeGoal = profile?.dailyActiveMinuteGoal ??
                          AppConstants.defaultDailyActiveMinutes;
                      final walkGoal = profile?.dailyWalkGoal ??
                          AppConstants.defaultDailyWalks;
                      final overallProgress = act.goalProgress(
                        stepGoal: stepGoal,
                        distanceGoal: distGoal,
                        activeMinuteGoal: activeGoal,
                        walkGoal: walkGoal,
                      );

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Streak ──────────────────────────────────
                            streakAsync.when(
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                              data: (s) =>
                                  s != null && s.currentStreak > 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16),
                                          child: StreakBanner(streak: s),
                                        )
                                      : const SizedBox.shrink(),
                            ),

                            // ── Hero activity card ───────────────────────
                            _HeroActivityCard(
                              activity: act,
                              stepGoal: stepGoal,
                              overallProgress: overallProgress,
                            ),
                            const SizedBox(height: 20),

                            // ── 4 stat chips ─────────────────────────────
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.5,
                              children: [
                                KuroStatChip(
                                  icon: Icons.route_rounded,
                                  value: FitnessUtils.formatDistance(
                                      act.distanceKm),
                                  label: s.distanceLabel,
                                  color: KColors.walkColor,
                                ),
                                KuroStatChip(
                                  icon: Icons.timer_rounded,
                                  value: '${act.activeMinutes}m',
                                  label: s.activeLabel,
                                  color: KColors.progressColor,
                                ),
                                KuroStatChip(
                                  icon: Icons.directions_walk_rounded,
                                  value: '${act.walkCount}',
                                  label: s.walksLabel,
                                  color: KColors.accent,
                                ),
                                KuroStatChip(
                                  icon:
                                      Icons.local_fire_department_rounded,
                                  value:
                                      '${act.calories.toStringAsFixed(0)}',
                                  label: s.kcalLabel,
                                  color: KColors.calorieColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // ── Start walk CTA ───────────────────────────
                            _StartWalkCard(),
                            const SizedBox(height: 24),

                            // ── Today's workout ──────────────────────────
                            KuroSectionHeader(
                              title: s.todayWorkout,
                              action: s.viewAll,
                              onAction: () => context.go(AppRoutes.exercise),
                            ),
                            const SizedBox(height: 12),
                            TodayWorkoutCard(
                                workoutCompleted:
                                    act.workoutCompleted),
                            const SizedBox(height: 24),

                            // ── Daily goals ──────────────────────────────
                            KuroSectionHeader(
                              title: s.dailyGoals,
                              action: s.edit,
                              onAction: () =>
                                  context.push(AppRoutes.goalsSetup),
                            ),
                            const SizedBox(height: 12),
                            GoalListCard(
                              activity: act,
                              stepGoal: stepGoal,
                              distanceGoal: distGoal,
                              activeMinuteGoal: activeGoal,
                              walkGoal: walkGoal,
                            ),
                            const SizedBox(height: 24),

                            // ── Today's walks ────────────────────────────
                            KuroSectionHeader(
                              title: s.todayWalks,
                              action: s.history,
                              onAction: () =>
                                  context.push('/walk/history'),
                            ),
                            const SizedBox(height: 12),
                            const TodayWalksSummary(),

                            const SizedBox(height: 24),
                            KuroSparkleRow(text: s.keepMoving),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Hero activity card ───────────────────────────────────────────────────────
class _HeroActivityCard extends ConsumerWidget {
  final DailyActivity activity;
  final int stepGoal;
  final double overallProgress;

  const _HeroActivityCard({
    required this.activity,
    required this.stepGoal,
    required this.overallProgress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final pct = (overallProgress * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D1270), Color(0xFF1A0A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: KColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular progress
              _CircularSteps(
                steps: activity.steps,
                goal: stepGoal,
                progress: FitnessUtils.goalProgress(
                    activity.steps, stepGoal),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.todayActivityTitle,
                      style: TextStyle(
                        color: KColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Steps
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: FitnessUtils.formatStepsFull(
                                activity.steps),
                            style: const TextStyle(
                              color: KColors.neonBlue,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' / ${FitnessUtils.formatStepsFull(stepGoal)}',
                            style: const TextStyle(
                              color: KColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'steps',
                      style: TextStyle(
                        color: KColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: overallProgress,
                        backgroundColor:
                            KColors.primary.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            KColors.accent),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$pct% ${s.dailyGoalPct}',
                      style: const TextStyle(
                        color: KColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (overallProgress >= 1.0) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KuroImage(
                  asset: KuromiAssets.happy,
                  width: 60,
                  height: 60,
                  fallbackEmoji: '🎉',
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: KColors.progressColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: KColors.progressColor.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🎉', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Text(
                        'Daily goal completed!',
                        style: TextStyle(
                          color: KColors.progressColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Circular step progress ───────────────────────────────────────────────────
class _CircularSteps extends ConsumerWidget {
  final int steps;
  final int goal;
  final double progress;

  const _CircularSteps({
    required this.steps,
    required this.goal,
    required this.progress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 110,
            height: 110,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              backgroundColor: Colors.transparent,
              color: KColors.primary.withOpacity(0.12),
            ),
          ),
          // Progress circle
          SizedBox(
            width: 110,
            height: 110,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 10,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  KColors.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.directions_walk_rounded,
                  color: KColors.primary, size: 20),
              const SizedBox(height: 2),
              Text(
                FitnessUtils.formatSteps(steps),
                style: const TextStyle(
                  color: KColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Text(
                'steps',
                style: TextStyle(
                  color: KColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Start walk CTA ───────────────────────────────────────────────────────────
class _StartWalkCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: () => context.go(AppRoutes.walk),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0E4A3A), Color(0xFF1A0A2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: KColors.walkColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: KColors.walkColor.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: KColors.walkColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: KColors.walkColor.withOpacity(0.3)),
              ),
              child: const Icon(Icons.directions_walk_rounded,
                  color: KColors.walkColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start a Walk 🚶‍♀️',
                    style: TextStyle(
                      color: KColors.walkColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.tapToBeginTracking,
                    style: TextStyle(
                      color: KColors.textSecondary.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: KColors.walkColor.withOpacity(0.7), size: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Loading / error states ───────────────────────────────────────────────────
class _HomeLoader extends StatelessWidget {
  const _HomeLoader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KuroImage(
              asset: KuromiAssets.chilling,
              width: 100,
              height: 100,
              fallbackEmoji: '😌',
            ),
            const SizedBox(height: 16),
            SafeLottie(
              asset: 'assets/animations/loading.json',
              width: 60,
              height: 60,
              repeat: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Text(
          'Could not load activity data',
          style: TextStyle(color: KColors.textSecondary),
        ),
      ),
    );
  }
}
