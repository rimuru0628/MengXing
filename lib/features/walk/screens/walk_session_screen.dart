import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/widgets/blackwater_effect.dart';
import '../providers/walk_provider.dart';
import '../../profile/providers/profile_provider.dart';

class WalkSessionScreen extends ConsumerStatefulWidget {
  const WalkSessionScreen({super.key});

  @override
  ConsumerState<WalkSessionScreen> createState() => _WalkSessionScreenState();
}

class _WalkSessionScreenState extends ConsumerState<WalkSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walkNotifierProvider.notifier).startWalk(useGps: false);
    });
  }

  Future<void> _stopWalk() async {
    final profile = ref.read(profileProvider).valueOrNull;
    final weight = profile?.weightKg ?? 70;
    final session = await ref
        .read(walkNotifierProvider.notifier)
        .stopWalk(weightKg: weight);
    if (!mounted) return;
    if (session != null) {
      context.pushReplacement('/walk/summary', extra: session.walkId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walkState = ref.watch(walkNotifierProvider);
    final s = ref.watch(stringsProvider);
    final isPaused = walkState.status == WalkState.paused;
    final elapsed = Duration(seconds: walkState.elapsedSeconds);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Stack(
        children: [
          // Blackwater flows at the bottom — you're walking through it
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlackwaterEffect(
              height: 180,
              waveCount: 3,
              showRipples: true,
            ),
          ),
          Container(
            decoration: const BoxDecoration(gradient: KColors.bgGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: KColors.accent),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => _DiscardDialog(
                          onDiscard: () {
                            ref
                                .read(walkNotifierProvider.notifier)
                                .reset();
                            Navigator.pop(context);
                            context.pop();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        isPaused ? s.walkPausedTitle : s.walkSessionTitle,
                        style: const TextStyle(
                          color: KColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const Spacer(),

              // Big timer circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      KColors.primary.withOpacity(0.2),
                      KColors.bg,
                    ],
                  ),
                  border: Border.all(
                      color: isPaused
                          ? KColors.accent.withOpacity(0.4)
                          : KColors.walkColor.withOpacity(0.5),
                      width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: (isPaused ? KColors.accent : KColors.walkColor)
                          .withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppDateUtils.formatDuration(elapsed),
                      style: const TextStyle(
                        color: KColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'duration',
                      style: TextStyle(
                          color: KColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCol(
                      label: s.stepsCount,
                      value: FitnessUtils.formatStepsFull(
                          walkState.steps),
                      color: KColors.neonBlue,
                    ),
                    _StatCol(
                      label: s.distanceLabel,
                      value: FitnessUtils.formatDistance(
                          walkState.distanceKm),
                      color: KColors.walkColor,
                    ),
                    _StatCol(
                      label: s.paceLabel,
                      value: walkState.paceMinPerKm > 0
                          ? '${walkState.paceMinPerKm.toStringAsFixed(1)}'
                          : '--',
                      sub: 'min/km',
                      color: KColors.neonPurple,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Safety note
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  s.safetyNoteWalk,
                  style: TextStyle(
                    color: KColors.textHint.withOpacity(0.7),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Controls
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Row(
                  children: [
                    // Pause / resume
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: isPaused
                              ? () => ref
                                  .read(walkNotifierProvider.notifier)
                                  .resume()
                              : () => ref
                                  .read(walkNotifierProvider.notifier)
                                  .pause(),
                          icon: Icon(
                            isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: KColors.accent,
                          ),
                          label: Text(
                            isPaused ? 'Resume' : 'Pause',
                            style:
                                const TextStyle(color: KColors.accent),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: KColors.accent, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Stop
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF8B1A1A),
                                Color(0xFFD63031)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _stopWalk,
                            icon: const Icon(Icons.stop_rounded,
                                color: Colors.white),
                            label: Text(s.stopWalk,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ), // Container
        ], // Stack
      ), // Stack
    );
  }
}

class _StatCol extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color color;
  const _StatCol(
      {required this.label,
      required this.value,
      this.sub,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900)),
        if (sub != null)
          Text(sub!,
              style: const TextStyle(
                  color: KColors.textSecondary, fontSize: 11)),
        Text(label,
            style: const TextStyle(
                color: KColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _DiscardDialog extends ConsumerWidget {
  final VoidCallback onDiscard;
  const _DiscardDialog({required this.onDiscard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return AlertDialog(
      backgroundColor: KColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(s.stopWalkQuestion,
          style: TextStyle(color: KColors.textPrimary, fontWeight: FontWeight.w700)),
      content: const Text(
          'Your current walk progress will be lost.',
          style: TextStyle(color: KColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.keepWalkingBtn,
              style: TextStyle(color: KColors.accent)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDiscard();
          },
          child: Text(s.discardBtn,
              style: TextStyle(color: Color(0xFFD63031))),
        ),
      ],
    );
  }
}
