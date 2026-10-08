import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/user_profile.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  Gender? _gender;
  FitnessLevel _level = FitnessLevel.beginner;
  FitnessGoal _goal = FitnessGoal.stayActive;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    final profile = UserProfile(
      userId: user!.uid,
      name: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text),
      heightCm: double.tryParse(_heightCtrl.text),
      weightKg: double.tryParse(_weightCtrl.text),
      gender: _gender,
      fitnessLevel: _level,
      fitnessGoal: _goal,
      createdAt: DateTime.now(),
    );

    await ref.read(profileNotifierProvider.notifier).createProfile(profile);
    if (!mounted) return;
    final state = ref.read(profileNotifierProvider);
    if (state is AsyncError) {
      context.showErrorSnackBar('Failed to save profile. Please try again.');
    } else {
      context.go(AppRoutes.goalsSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileNotifierProvider) is AsyncLoading;
    final s = ref.watch(stringsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.setUpYourProfile)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tellUsAboutYou,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  s.helpPersonalize,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.grey500),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: s.yourNameHint,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                    labelText: s.ageHint,
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _GenderDropdown(
                        value: _gender,
                        onChanged: (g) => setState(() => _gender = g),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                    labelText: s.heightHint,
                          prefixIcon: Icon(Icons.height_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _weightCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                    labelText: s.weightHint,
                          prefixIcon: Icon(Icons.monitor_weight_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(s.fitnessLevelTitle,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                _LevelSelector(
                  selected: _level,
                  onChanged: (l) => setState(() => _level = l),
                ),
                const SizedBox(height: 28),
                Text(s.myPrimaryGoal,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                _GoalSelector(
                  selected: _goal,
                  onChanged: (g) => setState(() => _goal = g),
                ),
                const SizedBox(height: 40),
                AppButton(
                  label: s.nextSetGoals,
                  onPressed: _save,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderDropdown extends ConsumerWidget {
  final Gender? value;
  final ValueChanged<Gender?> onChanged;
  const _GenderDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return DropdownButtonFormField<Gender>(
      value: value,
      decoration: InputDecoration(
                    labelText: s.genderHint,
        prefixIcon: Icon(Icons.wc_rounded),
      ),
      items: [
        DropdownMenuItem(value: Gender.male, child: Text(s.maleLabel)),
        DropdownMenuItem(value: Gender.female, child: Text(s.femaleLabel)),
        DropdownMenuItem(value: Gender.nonBinary, child: Text(s.nonBinaryLabel)),
        DropdownMenuItem(
            value: Gender.preferNotToSay, child: Text(s.preferNotToSayLabel)),
      ],
      onChanged: onChanged,
    );
  }
}

class _LevelSelector extends ConsumerWidget {
  final FitnessLevel selected;
  final ValueChanged<FitnessLevel> onChanged;
  const _LevelSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final levels = [
      (FitnessLevel.beginner, '🌱', s.beginnerLabel, s.beginnerSub),
      (FitnessLevel.intermediate, '🏃', s.intermediateLabel, s.intermediateSub),
      (FitnessLevel.advanced, '🏆', s.advancedLabel, s.advancedSub),
    ];
    return Column(
      children: levels.map((l) {
        final isSelected = selected == l.$1;
        return GestureDetector(
          onTap: () => onChanged(l.$1),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Text(l.$2, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.$3,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isSelected ? AppColors.primary : null,
                              )),
                      Text(l.$4,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.grey500)),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 22),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GoalSelector extends ConsumerWidget {
  final FitnessGoal selected;
  final ValueChanged<FitnessGoal> onChanged;
  const _GoalSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final goals = [
      (FitnessGoal.stayActive, '🏃', s.stayActiveGoal),
      (FitnessGoal.loseWeight, '⚖️', s.loseWeightGoal),
      (FitnessGoal.buildEndurance, '🫀', s.buildEnduranceGoal),
      (FitnessGoal.buildStrength, '💪', s.buildStrengthGoal),
      (FitnessGoal.improveHealth, '❤️', s.improveHealthGoal),
      (FitnessGoal.runFaster, '⚡', s.runFasterGoal),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: goals.map((g) {
        final isSelected = selected == g.$1;
        return GestureDetector(
          onTap: () => onChanged(g.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey300,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(g.$2, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(g.$3,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected ? AppColors.primary : null,
                          fontWeight: isSelected ? FontWeight.w600 : null,
                        )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
