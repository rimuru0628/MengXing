import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/services_providers.dart';
import '../../../shared/widgets/app_button.dart';

class _PermissionItem {
  final IconData icon;
  final Color color;
  final String title;
  final String reason;
  final Permission? permission;
  bool granted;

  _PermissionItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.reason,
    this.permission,
    this.granted = false,
  });
}

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  final List<_PermissionItem> _permissions = [
    _PermissionItem(
      icon: Icons.directions_walk_rounded,
      color: AppColors.primary,
      title: 'Activity & Steps',
      reason: 'Required to automatically count your steps and detect walking sessions.',
      permission: Permission.activityRecognition,
    ),
    _PermissionItem(
      icon: Icons.health_and_safety_rounded,
      color: AppColors.accent,
      title: 'Health Data',
      reason: 'Reads your steps, distance, and active minutes from your phone\'s health platform.',
    ),
    _PermissionItem(
      icon: Icons.location_on_rounded,
      color: AppColors.secondary,
      title: 'Location (optional)',
      reason: 'Only used if you choose to record a GPS route during a walk. You can always walk without GPS.',
      permission: Permission.locationWhenInUse,
    ),
    _PermissionItem(
      icon: Icons.notifications_rounded,
      color: AppColors.exercisePurple,
      title: 'Notifications',
      reason: 'For workout reminders, step goal alerts, and streak notifications. You can change this anytime.',
      permission: Permission.notification,
    ),
  ];

  bool _requesting = false;

  Future<void> _requestAll() async {
    setState(() => _requesting = true);

    // Activity recognition
    final activity = await Permission.activityRecognition.request();
    _permissions[0].granted = activity.isGranted;

    // Health permissions via HealthService
    final health = ref.read(healthServiceProvider);
    final healthGranted = await health.requestPermissions();
    _permissions[1].granted = healthGranted;

    // Location (optional — don't force)
    final location = await Permission.locationWhenInUse.request();
    _permissions[2].granted = location.isGranted;

    // Notifications
    final notif = ref.read(notificationServiceProvider);
    final notifGranted = await notif.requestPermissions();
    _permissions[3].granted = notifGranted;

    setState(() => _requesting = false);
  }

  void _continue() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Icon(Icons.privacy_tip_rounded,
                  size: 48, color: AppColors.primary),
              const SizedBox(height: 20),
              Text(
                'App Permissions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'MengXing needs a few permissions to work best. All permissions are optional — you can still use the app without them.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.grey500),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: _permissions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) {
                    final p = _permissions[i];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: p.granted
                              ? AppColors.accent.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: p.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(p.icon, color: p.color, size: 22),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.title,
                                    style: Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 4),
                                Text(
                                  p.reason,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.grey500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (p.granted)
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.accent, size: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: _requesting ? 'Requesting...' : 'Grant Permissions',
                onPressed: _requesting ? null : _requestAll,
                isLoading: _requesting,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Continue Without Permissions',
                onPressed: _continue,
                outlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
