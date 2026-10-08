import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/walking_session.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../../core/l10n/locale_provider.dart';
import '../providers/walk_provider.dart';

class WalkScreen extends ConsumerWidget {
  const WalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walksAsync = ref.watch(todayWalksProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: const Text('Walking 🚶‍♀️',
                    style: TextStyle(
                        color: KColors.textPrimary,
                        fontWeight: FontWeight.w800)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.history_rounded,
                        color: KColors.accent),
                    onPressed: () => context.push('/walk/history'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Hero start CTA
                      _WalkHero(),
                      const SizedBox(height: 24),
                      walksAsync.when(
                        loading: () => Center(
                          child: CircularProgressIndicator(
                              color: KColors.primary),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (walks) => _TodayWalksSection(walks: walks),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalkHero extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3A3A), Color(0xFF1A0A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KColors.walkColor.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: KColors.walkColor.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          KuroImage(
            asset: KuromiAssets.walking,
            width: 120,
            height: 120,
            fallbackEmoji: '🚶',
          ),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [KColors.walkColor, KColors.neonPurple],
            ).createShader(b),
            child: Text(
              s.readyToWalkTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            s.trackStepsSubtitle,
            style: TextStyle(color: KColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [KColors.walkColor, KColors.neonPurple],
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: KColors.walkColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => context.push('/walk/session'),
                icon: const Icon(Icons.play_arrow_rounded,
                    color: KColors.bg),
                label: Text(
                  s.startWalkButton,
                  style: const TextStyle(
                    color: KColors.bg,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayWalksSection extends ConsumerWidget {
  final List<WalkingSession> walks;
  const _TodayWalksSection({required this.walks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final totalSteps = walks.fold(0, (s, w) => s + w.steps);
    final totalDist = walks.fold(0.0, (s, w) => s + w.distanceKm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (walks.isNotEmpty) ...[
          // Summary row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KColors.card,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: KColors.border.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SumItem(
                  emoji: '🚶',
                  value: '${walks.length}',
                  label: s.walksToday2,
                  color: KColors.accent,
                ),
                Container(width: 1, height: 36, color: KColors.divider),
                _SumItem(
                  emoji: '📍',
                  value: FitnessUtils.formatDistance(totalDist),
                  label: s.totalDist2,
                  color: KColors.walkColor,
                ),
                Container(width: 1, height: 36, color: KColors.divider),
                _SumItem(
                  emoji: '👟',
                  value: FitnessUtils.formatStepsFull(totalSteps),
                  label: s.stepsCount,
                  color: KColors.neonPurple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        KuroSectionHeader(
          title: s.todayWalksSection,
          action: walks.isNotEmpty ? 'See All' : null,
          onAction: walks.isNotEmpty
              ? () => context.push('/walk/history')
              : null,
        ),
        const SizedBox(height: 12),
        if (walks.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: KColors.card,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: KColors.border.withOpacity(0.2)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KuroImage(
                    asset: KuromiAssets.walkingStill,
                    width: 90,
                    height: 90,
                    fallbackEmoji: '🚶‍♀️',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s.noWalksYetWalk,
                    style: TextStyle(
                      color: KColors.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...walks.asMap().entries.map(
                (e) => _WalkTile(walk: e.value, index: e.key + 1),
              ),
      ],
    );
  }
}

class _SumItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;
  const _SumItem(
      {required this.emoji,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 15)),
        Text(label,
            style: const TextStyle(
                color: KColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _WalkTile extends StatelessWidget {
  final WalkingSession walk;
  final int index;
  const _WalkTile({required this.walk, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KColors.border.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: KColors.walkColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('$index',
                  style: const TextStyle(
                      color: KColors.walkColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Walk $index',
                    style: const TextStyle(
                        color: KColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                Text(AppDateUtils.formatTime(walk.startTime),
                    style: const TextStyle(
                        color: KColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          _Pill(
              value: AppDateUtils.formatDuration(
                  Duration(seconds: walk.durationSeconds))),
          const SizedBox(width: 6),
          _Pill(value: FitnessUtils.formatDistance(walk.distanceKm)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String value;
  const _Pill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: KColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KColors.primary.withOpacity(0.2)),
      ),
      child: Text(value,
          style: const TextStyle(
              color: KColors.neonPurple, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
