import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/models/challenge.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../providers/challenges_provider.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        actions: [
          TextButton.icon(
            onPressed: () =>
                ref.read(challengesNotifierProvider.notifier).initDefaultChallenges(),
            icon: const Icon(Icons.add),
            label: const Text('Add Challenges'),
          ),
        ],
      ),
      body: challengesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load challenges')),
        data: (challenges) {
          if (challenges.isEmpty) {
            return EmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'No challenges yet',
              subtitle: 'Tap "Add Challenges" to get started',
              actionLabel: 'Add Default Challenges',
              onAction: () => ref
                  .read(challengesNotifierProvider.notifier)
                  .initDefaultChallenges(),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ChallengeCard(challenge: challenges[i]),
          );
        },
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  const _ChallengeCard({required this.challenge});

  Color get _statusColor {
    switch (challenge.status) {
      case ChallengeStatus.completed: return AppColors.accent;
      case ChallengeStatus.failed: return AppColors.error;
      case ChallengeStatus.inProgress: return AppColors.primary;
      default: return AppColors.grey500;
    }
  }

  String get _statusLabel {
    switch (challenge.status) {
      case ChallengeStatus.completed: return 'Completed ✓';
      case ChallengeStatus.failed: return 'Missed';
      case ChallengeStatus.inProgress: return 'In Progress';
      default: return 'Not Started';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _statusColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(challenge.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            )),
                    Text(
                      _typeBadge(challenge.type),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _statusColor,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            challenge.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 12),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: challenge.progress,
                    backgroundColor: _statusColor.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${challenge.currentValue.toStringAsFixed(0)} / '
                '${challenge.targetValue.toStringAsFixed(0)} ${challenge.unit}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ends ${AppDateUtils.formatDate(challenge.endDate)}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.grey400),
          ),
        ],
      ),
    );
  }

  String _typeBadge(ChallengeType type) {
    switch (type) {
      case ChallengeType.daily: return 'Daily Challenge';
      case ChallengeType.weekly: return 'Weekly Challenge';
      case ChallengeType.monthly: return 'Monthly Challenge';
    }
  }
}
