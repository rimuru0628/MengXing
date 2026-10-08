import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../providers/profile_provider.dart';

class GoalsSetupScreen extends ConsumerStatefulWidget {
  const GoalsSetupScreen({super.key});

  @override
  ConsumerState<GoalsSetupScreen> createState() => _GoalsSetupScreenState();
}

class _GoalsSetupScreenState extends ConsumerState<GoalsSetupScreen> {
  int _dailySteps = AppConstants.defaultDailySteps;
  double _dailyDistanceKm = AppConstants.defaultDailyDistanceKm;
  int _dailyActiveMinutes = AppConstants.defaultDailyActiveMinutes;
  int _dailyWalks = AppConstants.defaultDailyWalks;

  Future<void> _save() async {
    await ref.read(profileNotifierProvider.notifier).updateProfile({
      'dailyStepGoal': _dailySteps,
      'dailyWalkingGoalKm': _dailyDistanceKm,
      'dailyActiveMinuteGoal': _dailyActiveMinutes,
      'dailyWalkGoal': _dailyWalks,
    });
    if (!mounted) return;
    context.go(AppRoutes.permissionsSetup);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileNotifierProvider) is AsyncLoading;
    final s = ref.watch(stringsProvider);

    return Scaffold(
      appBar: AppBar(title: Consumer(builder: (c,r,_)=>Text(r.watch(stringsProvider).setDailyGoalsTitle))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Your Daily Goals',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                s.goalsAdjustable,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.grey500),
              ),
              const SizedBox(height: 32),
              _GoalSlider(
                icon: Icons.directions_walk_rounded,
                color: AppColors.primary,
                label: s.dailyStepsGoal,
                value: _dailySteps.toDouble(),
                min: 1000,
                max: 20000,
                divisions: 190,
                displayValue: '${_dailySteps.toStringAsFixed(0)} steps',
                onChanged: (v) => setState(() => _dailySteps = v.round()),
              ),
              const SizedBox(height: 24),
              _GoalSlider(
                icon: Icons.route_rounded,
                color: AppColors.walkBlue,
                label: s.walkingDistanceGoal,
                value: _dailyDistanceKm,
                min: 0.5,
                max: 20,
                divisions: 39,
                displayValue:
                    '${_dailyDistanceKm.toStringAsFixed(1)} km',
                onChanged: (v) =>
                    setState(() => _dailyDistanceKm = double.parse(v.toStringAsFixed(1))),
              ),
              const SizedBox(height: 24),
              _GoalSlider(
                icon: Icons.timer_rounded,
                color: AppColors.accent,
                label: s.activeMinutesGoal,
                value: _dailyActiveMinutes.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                displayValue: '$_dailyActiveMinutes min',
                onChanged: (v) =>
                    setState(() => _dailyActiveMinutes = v.round()),
              ),
              const SizedBox(height: 24),
              _GoalSlider(
                icon: Icons.replay_rounded,
                color: AppColors.secondary,
                label: s.numberOfWalksGoal,
                value: _dailyWalks.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                displayValue: '$_dailyWalks walks',
                onChanged: (v) => setState(() => _dailyWalks = v.round()),
              ),
              const SizedBox(height: 40),
              AppButton(
                label: s.nextPermissions,
                onPressed: _save,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String displayValue;
  final ValueChanged<double> onChanged;

  const _GoalSlider({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Text(
                displayValue,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.1),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toStringAsFixed(0)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.grey500)),
              Text('${max.toStringAsFixed(0)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.grey500)),
            ],
          ),
        ],
      ),
    );
  }
}
