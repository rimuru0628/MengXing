import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/models/achievement.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../providers/achievements_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);
    final all = AchievementDefinition.definitions;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: achievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load achievements')),
        data: (unlocked) {
          final unlockedMap = {for (var a in unlocked) a.type: a};
          final total = all.length;
          final unlockedCount = unlocked.where((a) => a.isUnlocked).length;

          return Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.goldBadge, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    KuroImage(
                      asset: KuromiAssets.blush,
                      width: 56,
                      height: 56,
                      fallbackEmoji: '🏆',
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$unlockedCount / $total Unlocked',
                            style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Keep going to unlock more!',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.8)),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: unlockedCount / total,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: all.length,
                  itemBuilder: (_, i) {
                    final type = all.keys.elementAt(i);
                    final def = all.values.elementAt(i);
                    final achievement = unlockedMap[type];
                    final isUnlocked = achievement?.isUnlocked ?? false;

                    return _AchievementBadge(
                      definition: def,
                      isUnlocked: isUnlocked,
                      unlockedAt: achievement?.unlockedAt,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final AchievementDefinition definition;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const _AchievementBadge({
    required this.definition,
    required this.isUnlocked,
    this.unlockedAt,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(definition.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(definition.emoji,
                  style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(definition.description,
                  textAlign: TextAlign.center),
              if (isUnlocked && unlockedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Unlocked on ${AppDateUtils.formatDate(unlockedAt!)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.accent),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? definition.color.withOpacity(0.1)
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnlocked
                ? definition.color.withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: isUnlocked
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.srcATop)
                  : const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
              child: Text(
                definition.emoji,
                style: TextStyle(fontSize: isUnlocked ? 32 : 28),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              definition.title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isUnlocked ? definition.color : AppColors.grey400,
                    fontWeight:
                        isUnlocked ? FontWeight.w600 : FontWeight.normal,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked)
              const Icon(Icons.check_circle_rounded,
                  size: 14, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
