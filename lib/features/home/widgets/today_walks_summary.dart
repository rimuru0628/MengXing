import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/walking_session.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../walk/providers/walk_provider.dart';

class TodayWalksSummary extends ConsumerWidget {
  const TodayWalksSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final walksAsync = ref.watch(todayWalksProvider);

    return walksAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: KColors.primary)),
      error: (_, __) => const SizedBox.shrink(),
      data: (walks) {
        if (walks.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KColors.card,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: KColors.border.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('🚶', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.noWalksYetHome,
                        style: TextStyle(
                          color: KColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        s.tapStartWalk,
                        style: TextStyle(
                          color: KColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: walks
              .asMap()
              .entries
              .map((e) => _WalkTile(walk: e.value, index: e.key + 1))
              .toList(),
        );
      },
    );
  }
}

class _WalkTile extends StatelessWidget {
  final WalkingSession walk;
  final int index;
  const _WalkTile({required this.walk, required this.index});

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: walk.durationSeconds);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KColors.border.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: KColors.walkColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: KColors.walkColor.withOpacity(0.25)),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: KColors.walkColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Walk $index',
                  style: const TextStyle(
                    color: KColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  AppDateUtils.formatTime(walk.startTime),
                  style: const TextStyle(
                    color: KColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppDateUtils.formatDuration(duration),
                style: const TextStyle(
                  color: KColors.walkColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              Text(
                FitnessUtils.formatDistance(walk.distanceKm),
                style: const TextStyle(
                  color: KColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${walk.steps}',
                style: const TextStyle(
                  color: KColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const Text(
                'steps',
                style: TextStyle(
                  color: KColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
