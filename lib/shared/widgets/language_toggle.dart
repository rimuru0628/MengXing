import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/kuromi_theme.dart';
import '../../core/l10n/locale_provider.dart';

/// Compact EN | 中文 toggle button — drop it anywhere
class LanguageToggle extends ConsumerWidget {
  final bool compact;
  const LanguageToggle({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(localeProvider.notifier);
    final isChinese = ref.watch(localeProvider).languageCode == 'zh';

    if (compact) {
      // Small icon-only button for app bars
      return GestureDetector(
        onTap: notifier.toggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: KColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: KColors.primary.withOpacity(0.3)),
          ),
          child: Text(
            isChinese ? '🇺🇸 EN' : '🇨🇳 中文',
            style: const TextStyle(
              color: KColors.neonPurple,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    // Full toggle for settings / login
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KColors.border.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangChip(
            label: '🇺🇸  English',
            selected: !isChinese,
            onTap: notifier.setEnglish,
          ),
          const SizedBox(width: 4),
          _LangChip(
            label: '🇨🇳  中文',
            selected: isChinese,
            onTap: notifier.setChinese,
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          gradient: selected ? KColors.primaryGradient : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: KColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : KColors.textSecondary,
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
