import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/providers/services_providers.dart';
import '../../../shared/widgets/language_toggle.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      appBar: AppBar(
        backgroundColor: KColors.bg,
        foregroundColor: KColors.textPrimary,
        title: Text(s.settings,
            style: const TextStyle(
                color: KColors.textPrimary, fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: ListView(
          children: [
            // ── Account ────────────────────────────────────────────────────
            _SectionTitle(s.accountSection),
            _KTile(
              icon: Icons.person_outline,
              title: s.editProfileBtn,
              onTap: () => context.push(AppRoutes.profileSetup),
            ),
            _KTile(
              icon: Icons.flag_rounded,
              title: s.dailyGoalsCardTitle,
              onTap: () => context.push(AppRoutes.goalsSetup),
            ),
            _KTile(
              icon: Icons.mail_outline,
              title: 'Email Verification',
              onTap: () async {
                await ref.read(authServiceProvider).sendEmailVerification();
                if (context.mounted) {
                  context.showSnackBar('Verification email sent!');
                }
              },
            ),

            const _KDivider(),

            // ── Language ────────────────────────────────────────────────────
            _SectionTitle(s.languageLabel2),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌐  ${s.language}',
                    style: const TextStyle(
                      color: KColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const LanguageToggle(),
                ],
              ),
            ),

            const _KDivider(),

            // ── App ──────────────────────────────────────────────────────────
            _SectionTitle(s.app),
            _KTile(
              icon: Icons.notifications_outlined,
              title: s.notifications,
              subtitle: s.manageNotifications,
              onTap: () => _showNotificationSettings(context),
            ),
            _KTile(
              icon: Icons.health_and_safety_outlined,
              title: s.healthPermissions,
              subtitle: s.manageHealth,
              onTap: () => context.push(AppRoutes.permissionsSetup),
            ),
            _KTile(
              icon: Icons.location_on_outlined,
              title: s.locationPermission,
              subtitle: s.locationSub,
              onTap: () => context.push(AppRoutes.permissionsSetup),
            ),

            const _KDivider(),

            // ── Data & Privacy ───────────────────────────────────────────────
            _SectionTitle(s.dataPrivacy),
            _KTile(
              icon: Icons.sync_rounded,
              title: s.syncData,
              subtitle: s.syncSub,
              onTap: () => context.showSnackBar('Syncing data...'),
            ),
            _KTile(
              icon: Icons.privacy_tip_outlined,
              title: s.privacyPolicy,
              onTap: () {},
            ),

            const _KDivider(),

            // ── Account Actions ──────────────────────────────────────────────
            _SectionTitle(s.accountActions),
            _KTile(
              icon: Icons.logout_rounded,
              title: s.signOut,
              titleColor: const Color(0xFFD63031),
              onTap: () => _showSignOutDialog(context, ref, s),
            ),
            _KTile(
              icon: Icons.delete_forever_rounded,
              title: s.deleteAccount,
              titleColor: const Color(0xFFD63031),
              subtitle: s.deleteAccountSub,
              onTap: () => _showDeleteDialog(context, ref, s),
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'MengXing v${AppConstants.appVersion}',
                style: const TextStyle(color: KColors.textHint, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bCtx) => Consumer(
        builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.notificationsLabel,
                  style: const TextStyle(
                      color: KColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              const SizedBox(height: 16),
              _NotifTile(emoji: '💪', label: s.isChinese ? '训练提醒' : 'Workout Reminder', time: '7:00 AM'),
              _NotifTile(emoji: '🚶', label: s.isChinese ? '步行提醒' : 'Walk Reminder', time: '12:00 PM'),
              _NotifTile(emoji: '🔥', label: s.isChinese ? '连续记录提醒' : 'Streak Reminder', time: '8:00 PM'),
            ],
        ),
      );
        }),
    );
  }

  void _showSignOutDialog(
      BuildContext context, WidgetRef ref, AppStrings s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: KColors.card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s.signOutQ,
            style: const TextStyle(
                color: KColors.textPrimary, fontWeight: FontWeight.w700)),
        content: Text(s.signOutMsg,
            style: const TextStyle(color: KColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.cancel,
                  style: const TextStyle(color: KColors.accent))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: Text(s.signOut,
                style: const TextStyle(color: Color(0xFFD63031))),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, AppStrings s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: KColors.card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s.deleteAccount,
            style: const TextStyle(
                color: KColors.textPrimary, fontWeight: FontWeight.w700)),
        content: Text(s.deleteAccountSub,
            style: const TextStyle(color: KColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.cancel,
                  style: const TextStyle(color: KColors.accent))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).deleteAccount();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFD63031))),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable widgets ──────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
        child: Text(title,
            style: const TextStyle(
              color: KColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
            )),
      );
}

class _KTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _KTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          color: titleColor ?? KColors.primary, size: 22),
      title: Text(title,
          style: TextStyle(
              color: titleColor ?? KColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 12))
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios_rounded,
                  size: 13, color: KColors.textHint)
              : null),
      onTap: onTap,
    );
  }
}

class _KDivider extends StatelessWidget {
  const _KDivider();
  @override
  Widget build(BuildContext context) =>
      Divider(color: KColors.divider, height: 1, thickness: 1);
}

class _NotifTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String time;
  const _NotifTile(
      {required this.emoji, required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 22)),
      title: Text(label,
          style: const TextStyle(color: KColors.textPrimary, fontSize: 14)),
      subtitle: Text(time,
          style:
              const TextStyle(color: KColors.textSecondary, fontSize: 12)),
      trailing: Switch(value: true, onChanged: null),
    );
  }
}
