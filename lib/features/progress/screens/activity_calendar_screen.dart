import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/daily_activity.dart';
import '../../../shared/providers/services_providers.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../auth/providers/auth_provider.dart';

class ActivityCalendarScreen extends ConsumerStatefulWidget {
  const ActivityCalendarScreen({super.key});

  @override
  ConsumerState<ActivityCalendarScreen> createState() =>
      _ActivityCalendarScreenState();
}

class _ActivityCalendarScreenState
    extends ConsumerState<ActivityCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<String, DailyActivity> _activities = {};

  @override
  void initState() {
    super.initState();
    _loadMonth(_focusedDay);
  }

  Future<void> _loadMonth(DateTime month) async {
    final uid = ref.read(currentUserIdProvider);
    final start = AppDateUtils.startOfMonth(month);
    final end = DateTime(month.year, month.month + 1, 0);
    final list = await ref
        .read(firestoreServiceProvider)
        .getDailyActivitiesForRange(uid, start, end);
    setState(() {
      _activities = {for (var a in list) a.date: a};
    });
  }

  DailyActivity? get _selectedActivity =>
      _activities[AppDateUtils.toDateKey(_selectedDay)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) {
              _focusedDay = focused;
              _loadMonth(focused);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (_, day, events) {
                final key = AppDateUtils.toDateKey(day);
                final act = _activities[key];
                if (act == null || act.steps == 0) return null;
                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: act.goalCompleted
                          ? AppColors.accent
                          : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          if (_selectedActivity != null)
            Expanded(child: _DayDetail(activity: _selectedActivity!))
          else
            Expanded(
              child: EmptyState(
                icon: Icons.calendar_today_rounded,
                title: 'No activity on this day',
              ),
            ),
        ],
      ),
    );
  }
}

class _DayDetail extends StatelessWidget {
  final DailyActivity activity;
  const _DayDetail({required this.activity});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppDateUtils.formatDate(AppDateUtils.fromDateKey(activity.date)),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: [
              _DayStat(
                  icon: Icons.directions_walk_rounded,
                  color: AppColors.primary,
                  label: 'Steps',
                  value: FitnessUtils.formatStepsFull(activity.steps)),
              _DayStat(
                  icon: Icons.route_rounded,
                  color: AppColors.walkBlue,
                  label: 'Distance',
                  value: FitnessUtils.formatDistance(activity.distanceKm)),
              _DayStat(
                  icon: Icons.directions_walk_outlined,
                  color: AppColors.secondary,
                  label: 'Walks',
                  value: '${activity.walkCount}'),
              _DayStat(
                  icon: Icons.timer_rounded,
                  color: AppColors.accent,
                  label: 'Active Min',
                  value: '${activity.activeMinutes}'),
              _DayStat(
                  icon: Icons.fitness_center_rounded,
                  color: AppColors.exercisePurple,
                  label: 'Workout',
                  value: activity.workoutCompleted ? 'Done' : '—'),
              _DayStat(
                  icon: Icons.flag_rounded,
                  color: activity.goalCompleted ? AppColors.accent : AppColors.grey400,
                  label: 'Goal',
                  value: activity.goalCompleted ? 'Met ✓' : 'Not Met'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _DayStat(
      {required this.icon,
      required this.color,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.grey500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
