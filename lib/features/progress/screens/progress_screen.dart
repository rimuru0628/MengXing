import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/daily_activity.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../home/providers/home_provider.dart';
import '../providers/progress_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          KColors.neonGradient.createShader(b),
                      child: Text(
                        s.progressTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.calendar_month_rounded,
                          color: KColors.accent),
                      onPressed: () =>
                          context.push('/progress/calendar'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_events_rounded,
                          color: KColors.neonPurple),
                      onPressed: () =>
                          context.push(AppRoutes.achievements),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                decoration: BoxDecoration(
                  color: KColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabs,
                  indicator: BoxDecoration(
                    gradient: KColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: KColors.textSecondary,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Today'),
                    Tab(text: 'Week'),
                    Tab(text: 'Month'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: const [
                    _DailyTab(),
                    _WeeklyTab(),
                    _MonthlyTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Daily ───────────────────────────────────────────────────────────────────
class _DailyTab extends ConsumerWidget {
  const _DailyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final actAsync = ref.watch(todayActivityProvider);
    final streakAsync = ref.watch(streakProvider);

    return actAsync.when(
      loading: () => Center(
          child: CircularProgressIndicator(color: KColors.primary)),
      error: (_, __) => Center(
          child: Text(s.couldNotLoadLabel,
              style: TextStyle(color: KColors.textSecondary))),
      data: (act) {
        final a = act ?? DailyActivity.empty(DateTime.now());
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today · ${AppDateUtils.formatDate(DateTime.now())}',
                  style: const TextStyle(
                      color: KColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
                children: [
                  _StatTile('👟', s.stepsStatLabel,
                      FitnessUtils.formatStepsFull(a.steps),
                      KColors.neonBlue),
                  _StatTile('📍', s.distanceStatLabel,
                      FitnessUtils.formatDistance(a.distanceKm),
                      KColors.walkColor),
                  _StatTile('⏱', s.activeMinLabel, '${a.activeMinutes} ${s.min}',
                      KColors.progressColor),
                  _StatTile('🔥', s.caloriesLabel,
                      '${a.calories.toStringAsFixed(0)} kcal',
                      KColors.calorieColor),
                  _StatTile('🚶', s.walksStatLabel, '${a.walkCount}',
                      KColors.accent),
                  _StatTile(
                      '💪',
                      'Workout',
                      a.workoutCompleted ? s.doneLabel : s.pendingLabel,
                      a.workoutCompleted
                          ? KColors.progressColor
                          : KColors.primary),
                ],
              ),
              const SizedBox(height: 20),
              streakAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (s) => s != null
                    ? _StreakCard(
                        current: s.currentStreak,
                        longest: s.longestStreak,
                        total: s.totalDaysCompleted)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _StatTile(this.emoji, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          Text(label,
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StreakCard extends ConsumerWidget {
  final int current;
  final int longest;
  final int total;
  const _StreakCard(
      {required this.current,
      required this.longest,
      required this.total});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5A0E3A), Color(0xFF2E0A52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KColors.accent.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: KColors.accent.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$current${s.dayStreak2}',
                    style: const TextStyle(
                        color: KColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 20)),
                Text(s.keepFireBurning,
                    style: TextStyle(
                        color: KColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Column(
            children: [
              Text('$longest',
                  style: const TextStyle(
                      color: KColors.neonBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 22)),
              Text(s.bestLabel,
                  style: TextStyle(
                      color: KColors.textSecondary, fontSize: 11)),
              const SizedBox(height: 8),
              Text('$total',
                  style: const TextStyle(
                      color: KColors.neonPurple,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              Text(s.totalLabel,
                  style: TextStyle(
                      color: KColors.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Weekly ───────────────────────────────────────────────────────────────────
class _WeeklyTab extends ConsumerWidget {
  const _WeeklyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final summaryAsync = ref.watch(weeklySummaryProvider);
    return summaryAsync.when(
      loading: () => Center(
          child: CircularProgressIndicator(color: KColors.primary)),
      error: (_, __) => Center(
          child: Text(s.couldNotLoadLabel,
              style: TextStyle(color: KColors.textSecondary))),
      data: (summary) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _WeeklySummaryCard(summary: summary),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(s.stepsThisWeekLabel,
                  style: const TextStyle(
                      color: KColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: _StepsChart(activities: summary.days),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends ConsumerWidget {
  final WeeklySummary summary;
  const _WeeklySummaryCard({required this.summary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KColors.border.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WkStat(FitnessUtils.formatStepsFull(summary.totalSteps),
                  s.totalStepsLabel, KColors.neonBlue),
              _WkStat(
                  FitnessUtils.formatDistance(summary.totalDistanceKm),
                  s.distanceStatLabel,
                  KColors.walkColor),
              _WkStat('${summary.totalWalks}', s.walksStatLabel, KColors.accent),
            ],
          ),
          Divider(color: KColors.divider, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WkStat('${summary.totalActiveMinutes}', s.activeMinLabel,
                  KColors.progressColor),
              _WkStat('${summary.workoutsCompleted}', s.workoutsLabel,
                  KColors.primary),
              _WkStat(
                  FitnessUtils.formatSteps(summary.avgDailySteps.round()),
                  s.avgPerDayLabel,
                  KColors.neonPurple),
            ],
          ),
        ],
      ),
    );
  }
}

class _WkStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _WkStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 16)),
        Text(label,
            style: const TextStyle(
                color: KColors.textSecondary, fontSize: 11)),
      ]);
}

class _StepsChart extends ConsumerWidget {
  final List<DailyActivity> activities;
  const _StepsChart({required this.activities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    if (activities.isEmpty) {
      return Center(
          child: Text(s.noDataLabel,
              style: const TextStyle(color: KColors.textSecondary)));
    }
    final maxSteps =
        activities.fold(0, (m, a) => a.steps > m ? a.steps : m);
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxSteps * 1.25).toDouble().clamp(1000, double.infinity),
        barGroups: activities.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.steps.toDouble(),
                gradient: const LinearGradient(
                  colors: [KColors.primary, KColors.accent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 18,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= activities.length) {
                  return const SizedBox();
                }
                final date = AppDateUtils.fromDateKey(
                    activities[i].date);
                return Text(AppDateUtils.weekdayShort(date),
                    style: const TextStyle(
                        color: KColors.textSecondary, fontSize: 11));
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (_) => FlLine(
            color: KColors.divider.withOpacity(0.5),
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

// ─── Monthly ─────────────────────────────────────────────────────────────────
class _MonthlyTab extends ConsumerWidget {
  const _MonthlyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final activitiesAsync = ref.watch(monthlyActivitiesProvider);
    return activitiesAsync.when(
      loading: () => Center(
          child: CircularProgressIndicator(color: KColors.primary)),
      error: (_, __) => Center(
          child: Text(s.couldNotLoadLabel,
              style: TextStyle(color: KColors.textSecondary))),
      data: (activities) {
        final totalSteps = activities.fold(0, (s, a) => s + a.steps);
        final totalDist =
            activities.fold(0.0, (s, a) => s + a.distanceKm);
        final totalWalks = activities.fold(0, (s, a) => s + a.walkCount);
        final totalWorkouts =
            activities.where((a) => a.workoutCompleted).length;
        final goalDays = activities.where((a) => a.goalCompleted).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.thisMonthLabel,
                  style: TextStyle(
                      color: KColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
                children: [
                  _StatTile('👟', s.totalStepsLabel,
                      FitnessUtils.formatStepsFull(totalSteps),
                      KColors.neonBlue),
                  _StatTile('📍', s.distanceStatLabel,
                      FitnessUtils.formatDistance(totalDist),
                      KColors.walkColor),
                  _StatTile('🚶', s.totalWalksLabel, '$totalWalks',
                      KColors.accent),
                  _StatTile('💪', s.workoutsLabel, '$totalWorkouts',
                      KColors.primary),
                  _StatTile('🎯', s.goalDaysLabel, '$goalDays',
                      KColors.progressColor),
                  _StatTile('📅', s.activeDaysLabel, '${activities.length}',
                      KColors.neonPurple),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
