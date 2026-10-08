import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../widgets/lottie_widget.dart';
import '../widgets/lottie_widget.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/kuromi_theme.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../shared/providers/services_providers.dart';
import '../widgets/kuromi_image.dart';
import '../widgets/blackwater_effect.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _scaleCtrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(
        CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut));
    _fadeCtrl.forward();
    _scaleCtrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;
    final storage = ref.read(localStorageProvider);
    final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
    if (!storage.onboardingDone) {
      context.go(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.bg,
      body: Stack(
        children: [
          // Blackwater effect fills the bottom 40% of splash
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlackwaterEffect(
              height: MediaQuery.of(context).size.height * 0.4,
              waveCount: 3,
              showRipples: true,
            ),
          ),
          Container(
            decoration: const BoxDecoration(gradient: KColors.bgGradient),
            child: Center(
              child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Kuromi cute image
                  KuroImage(
                    asset: KuromiAssets.cute,
                    width: 120,
                    height: 120,
                    fallbackEmoji: '🖤',
                  ),
                  const SizedBox(height: 4),

                  // App icon — strength banner cropped to circle
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: KColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: KColors.primary.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/strength_banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Chinese name with gradient
                  ShaderMask(
                    shaderCallback: (b) =>
                        KColors.neonGradient.createShader(b),
                    child: const Text(
                      '梦行',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [KColors.accent, KColors.neonBlue],
                    ).createShader(b),
                    child: const Text(
                      'M E N G X I N G',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Daily Exercise & Walking Tracker',
                    style: TextStyle(
                      color: KColors.textSecondary,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Loading animation
                  SafeLottie(
                    asset: 'assets/animations/loading.json',
                    width: 80,
                    height: 80,
                    repeat: true,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('✦',
                          style: TextStyle(
                              color: KColors.accent, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(
                        'Stay active, stay magical',
                        style: TextStyle(
                          color: KColors.textHint.withOpacity(0.8),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('✦',
                          style: TextStyle(
                              color: KColors.neonBlue, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ], // Stack children
      ), // Stack
    );
  }
}
