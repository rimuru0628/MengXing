import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/user_profile.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../auth/providers/auth_provider.dart';
import '../../home/providers/home_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final profileAsync = ref.watch(profileProvider);
    final actAsync = ref.watch(todayActivityProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: profileAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: KColors.primary)),
            error: (_, __) => const Center(
                child: Text('Could not load profile',
                    style: TextStyle(color: KColors.textSecondary))),
            data: (profile) {
              if (profile == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🌸',
                            style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 16),
                        Text(s.profileNotSetUp,
                            style: TextStyle(
                                color: KColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                        const SizedBox(height: 24),
                        KuroButton(
                          label: s.setUpProfileBtn,
                          onPressed: () =>
                              context.push(AppRoutes.profileSetup),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header
                    _ProfileHeader(profile: profile),
                    const SizedBox(height: 20),

                    // Activity snapshot
                    actAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (act) => act != null
                          ? _ActivitySnap(activity: act)
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),

                    // Info
                    _InfoCard(profile: profile),
                    const SizedBox(height: 12),
                    _GoalsCard(profile: profile),
                    const SizedBox(height: 12),
                    _LinksCard(),
                    const SizedBox(height: 20),
                    _SignOutButton(),
                    const SizedBox(height: 20),
                    // Kuromi thanks
                    KuroImage(
                      asset: KuromiAssets.thanks,
                      width: 80,
                      height: 80,
                      fallbackEmoji: '🙏',
                    ),
                    const SizedBox(height: 8),
                    KuroSparkleRow(text: s.keepMovingShining),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (b) => KColors.neonGradient.createShader(b),
          child: Text(s.profileTitle,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded,
                color: KColors.accent),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
    );
  }
}

// ─── Profile header ───────────────────────────────────────────────────────────
class _ProfileHeader extends ConsumerWidget {
  final UserProfile profile;
  const _ProfileHeader({required this.profile});

  String _levelEmoji(FitnessLevel l, AppStrings s) {
    switch (l) {
      case FitnessLevel.beginner: return s.isChinese ? '🌱 初学者' : '🌱 Beginner';
      case FitnessLevel.intermediate: return s.isChinese ? '🏃 中级' : '🏃 Intermediate';
      case FitnessLevel.advanced: return s.isChinese ? '🏆 高级' : '🏆 Advanced';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A0E52), Color(0xFF1A0A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: KColors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: KColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: KColors.primary.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: profile.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(profile.avatarUrl!,
                            fit: BoxFit.cover))
                    : ClipOval(
                        child: KuroImage(
                          asset: KuromiAssets.classic,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          fallbackEmoji: '🖤',
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.profileSetup),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: KColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(profile.name,
              style: const TextStyle(
                  color: KColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
          const SizedBox(height: 4),
          Text(_levelEmoji(profile.fitnessLevel, s),
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── Activity snapshot ────────────────────────────────────────────────────────
class _ActivitySnap extends ConsumerWidget {
  final dynamic activity;
  const _ActivitySnap({required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KColors.border.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Snap(FitnessUtils.formatStepsFull(activity.steps),
              s.stepsTodayLabel, KColors.neonBlue),
          Container(width: 1, height: 36, color: KColors.divider),
          _Snap(FitnessUtils.formatDistance(activity.distanceKm),
              s.distanceStatLabel, KColors.walkColor),
          Container(width: 1, height: 36, color: KColors.divider),
          _Snap('${activity.activeMinutes}m', s.activeLabel, KColors.progressColor),
        ],
      ),
    );
  }
}

class _Snap extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _Snap(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 15)),
        Text(label,
            style: const TextStyle(
                color: KColors.textSecondary, fontSize: 11)),
      ]);
}

// ─── Info card ────────────────────────────────────────────────────────────────
class _InfoCard extends ConsumerWidget {
  final UserProfile profile;
  const _InfoCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final bmi =
        (profile.heightCm != null && profile.weightKg != null)
            ? FitnessUtils.calculateBmi(
                profile.weightKg!, profile.heightCm!)
            : null;

    return _KCard(
      title: s.personalInfoTitle,
      children: [
        if (profile.age != null)
          _Row(s.ageLabel, '${profile.age} years'),
        if (profile.heightCm != null)
          _Row(s.heightLabel,
              '${profile.heightCm!.toStringAsFixed(0)} cm'),
        if (profile.weightKg != null)
          _Row(s.weightLabel,
              '${profile.weightKg!.toStringAsFixed(1)} kg'),
        if (bmi != null)
          _Row(s.bmiLabel,
              '${bmi.toStringAsFixed(1)} · ${FitnessUtils.bmiCategory(bmi)}'),
      ],
    );
  }
}

class _GoalsCard extends ConsumerWidget {
  final UserProfile profile;
  const _GoalsCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return _KCard(
      title: s.dailyGoalsCardTitle,
      children: [
        _Row(s.stepsGoalLabel,
            FitnessUtils.formatStepsFull(profile.dailyStepGoal)),
        _Row(s.distanceGoalLabel,
            FitnessUtils.formatDistance(profile.dailyWalkingGoalKm)),
        _Row(s.activeMinGoalLabel,
            '${profile.dailyActiveMinuteGoal} min'),
        _Row(s.walksGoalLabel, '${profile.dailyWalkGoal}'),
      ],
    );
  }
}

class _LinksCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return _KCard(
      title: s.moreTitle,
      children: [
        _Link(Icons.emoji_events_rounded, s.achievementsTitle,
            () => context.push(AppRoutes.achievements),
            KColors.neonPurple),
        _Link(Icons.flag_rounded, s.challenges,
            () => context.push(AppRoutes.challenges), KColors.accent),
        _Link(Icons.smart_toy_outlined, s.aiAssistantLabel,
            () => context.push(AppRoutes.aiAssistant), KColors.neonBlue),
        _Link(Icons.settings_rounded, s.settingsTitle,
            () => context.push('/profile/settings'),
            KColors.textSecondary),
      ],
    );
  }
}

class _KCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _KCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KColors.border.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: KColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: KColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _Link(this.icon, this.label, this.onTap, this.color);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: KColors.textPrimary, fontSize: 14))),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: KColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ─── Sign out ─────────────────────────────────────────────────────────────────
class _SignOutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: KColors.card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text(s.signOutQuestion,
                style: TextStyle(
                    color: KColors.textPrimary,
                    fontWeight: FontWeight.w700)),
            content: Text(s.signOutMessage,
                style: const TextStyle(color: KColors.textSecondary)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(s.cancelBtn,
                      style: TextStyle(color: KColors.accent))),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref
                      .read(authNotifierProvider.notifier)
                      .signOut();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
                child: const Text('Sign Out',
                    style: TextStyle(color: Color(0xFFD63031))),
              ),
            ],
          ),
        ),
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFD63031)),
        label: const Text('Sign Out',
            style: TextStyle(color: Color(0xFFD63031))),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
              color: Color(0xFFD63031), width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
