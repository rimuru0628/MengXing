import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/walking_session.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../../core/l10n/locale_provider.dart';
import '../providers/walk_provider.dart';

class WalkHistoryScreen extends ConsumerStatefulWidget {
  const WalkHistoryScreen({super.key});

  @override
  ConsumerState<WalkHistoryScreen> createState() => _WalkHistoryScreenState();
}

class _WalkHistoryScreenState extends ConsumerState<WalkHistoryScreen>
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
      appBar: AppBar(
        backgroundColor: KColors.bg,
        foregroundColor: KColors.textPrimary,
        elevation: 0,
        title: Text(s.walkHistoryTitle,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: KColors.accent,
          labelColor: KColors.accent,
          unselectedLabelColor: KColors.textSecondary,
          tabs: [
            Tab(text: s.todayTab),
            Tab(text: s.weekTab),
            Tab(text: s.monthTab),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: TabBarView(
          controller: _tabs,
          children: [
            _WalkList(
                range: DateRange(AppDateUtils.startOfDay(DateTime.now()),
                    DateTime.now())),
            _WalkList(
                range: DateRange(AppDateUtils.startOfWeek(DateTime.now()),
                    DateTime.now())),
            _WalkList(
                range: DateRange(AppDateUtils.startOfMonth(DateTime.now()),
                    DateTime.now())),
          ],
        ),
      ),
    );
  }
}

class _WalkList extends ConsumerWidget {
  final DateRange range;
  const _WalkList({required this.range});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final walksAsync = ref.watch(walkHistoryProvider(range));
    return walksAsync.when(
      loading: () => Center(
          child: CircularProgressIndicator(color: KColors.primary)),
      error: (_, __) => Center(
          child: Text('Could not load history',
              style: TextStyle(color: KColors.textSecondary))),
      data: (walks) {
        if (walks.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                KuroImage(
                  asset: KuromiAssets.blankStare,
                  width: 110,
                  height: 110,
                  fallbackEmoji: '🚶',
                ),
                const SizedBox(height: 12),
                Text(s.noWalksInPeriod2,
                    style: const TextStyle(
                        color: KColors.textSecondary, fontSize: 15)),
              ],
            ),
          );
        }

        final totalSteps = walks.fold(0, (s, w) => s + w.steps);
        final totalDist = walks.fold(0.0, (s, w) => s + w.distanceKm);

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: KColors.border.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _HistStat('${walks.length}', s.walksStatLabel,
                      KColors.accent),
                  _HistStat(FitnessUtils.formatDistance(totalDist),
                      'Distance', KColors.walkColor),
                  _HistStat(
                      FitnessUtils.formatStepsFull(totalSteps),
                      'Steps',
                      KColors.neonPurple),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: walks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _HistoryTile(walk: walks[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HistStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _HistStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 16)),
        Text(label,
            style: const TextStyle(
                color: KColors.textSecondary, fontSize: 12)),
      ]);
}

class _HistoryTile extends StatelessWidget {
  final WalkingSession walk;
  const _HistoryTile({required this.walk});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KColors.border.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: KColors.walkColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_walk_rounded,
                color: KColors.walkColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppDateUtils.relativeDay(walk.startTime),
                    style: const TextStyle(
                        color: KColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                Text(
                  '${AppDateUtils.formatTime(walk.startTime)} · ${FitnessUtils.formatPace(walk.paceMinPerKm)}',
                  style: const TextStyle(
                      color: KColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(FitnessUtils.formatDistance(walk.distanceKm),
                  style: const TextStyle(
                      color: KColors.walkColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
              Text(
                  AppDateUtils.formatDuration(
                      Duration(seconds: walk.durationSeconds)),
                  style: const TextStyle(
                      color: KColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
