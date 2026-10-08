import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../shared/providers/services_providers.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';

class _Page {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final String sparkle;

  const _Page({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    this.sparkle = '✦',
  });
}

const _pages = [
  _Page(
    emoji: '🏃',
    title: 'Track Daily Activity',
    subtitle:
        'Monitor your steps, distance, and active minutes every day. Stay on top of your fitness journey.',
    color: KColors.primary,
    sparkle: '🌸',
  ),
  _Page(
    emoji: '👟',
    title: 'Count Your Steps',
    subtitle:
        'Your phone automatically counts steps using built-in sensors and health data. No extra device needed.',
    color: KColors.neonBlue,
    sparkle: '💜',
  ),
  _Page(
    emoji: '🗺️',
    title: 'Track Your Walks',
    subtitle:
        'Log every walk with duration, distance, and pace. Optionally record your GPS route.',
    color: KColors.accent,
    sparkle: '🩷',
  ),
  _Page(
    emoji: '💪',
    title: 'Daily Exercises',
    subtitle:
        'Follow personalized daily workouts with warm-up, main exercises, and cool-down routines.',
    color: KColors.neonPurple,
    sparkle: '⚡',
  ),
  _Page(
    emoji: '🎯',
    title: 'Set Personal Goals',
    subtitle:
        'Define your daily step goal, walking distance, active minutes, and workout targets.',
    color: KColors.accent,
    sparkle: '🌟',
  ),
  _Page(
    emoji: '📊',
    title: 'Monitor Progress',
    subtitle:
        'View daily, weekly, and monthly progress with charts, streaks, and achievement badges.',
    color: KColors.primary,
    sparkle: '🔮',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _current = 0;

  void _next() {
    if (_current < _pages.length - 1) {
      _ctrl.nextPage(
          duration: AppConstants.mediumAnim, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    ref.read(localStorageProvider).setOnboardingDone();
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_current];

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: _finish,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: KColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (_, i) => _OnboardingPage(page: _pages[i]),
                ),
              ),

              // Indicators + nav
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _ctrl,
                      count: _pages.length,
                      effect: WormEffect(
                        activeDotColor: page.color,
                        dotColor: page.color.withOpacity(0.25),
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [page.color, KColors.accent]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: page.color.withOpacity(0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            _current == _pages.length - 1
                                ? 'Get Started ✨'
                                : 'Next →',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
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
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _Page page;
  const _OnboardingPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji glow circle
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.color.withOpacity(0.12),
              border: Border.all(
                  color: page.color.withOpacity(0.25), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: page.color.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(page.emoji,
                  style: const TextStyle(fontSize: 70)),
            ),
          ),
          const SizedBox(height: 16),

          // Show Kuromi thanks on last page
          if (page.emoji == '📊')
            KuroImage(
              asset: KuromiAssets.thanks,
              width: 90,
              height: 90,
              fallbackEmoji: '🙏',
            ),

          // Sparkle
          Text(page.sparkle,
              style: TextStyle(
                  color: page.color.withOpacity(0.6), fontSize: 20)),

          const SizedBox(height: 28),

          // Title
          ShaderMask(
            shaderCallback: (b) => LinearGradient(
              colors: [page.color, KColors.accent],
            ).createShader(b),
            child: Text(
              page.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            page.subtitle,
            style: const TextStyle(
              color: KColors.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
