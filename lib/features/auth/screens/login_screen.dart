import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../../../shared/widgets/language_toggle.dart';
import '../../../shared/widgets/lottie_widget.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref.read(authNotifierProvider.notifier)
        .signInWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;
    setState(() => _isLoading = false);
    final state = ref.read(authNotifierProvider);
    if (state is AsyncError) {
      context.showErrorSnackBar(
          ref.read(stringsProvider).signIn + ' failed. Check your credentials.');
    } else {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);
    final state = ref.read(authNotifierProvider);
    if (state is AsyncError) {
      context.showErrorSnackBar('Google sign-in failed. Please try again.');
    } else if (state is! AsyncLoading) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: Container(
        decoration: const BoxDecoration(gradient: KColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Strength banner ─────────────────────────────────────
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/strength_banner.png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2A0E52), KColors.bg],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: const Center(
                          child: Text('🏋️', style: TextStyle(fontSize: 60)),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            KColors.bg.withOpacity(0.85),
                            KColors.bg,
                          ],
                          stops: const [0.3, 0.75, 1.0],
                        ),
                      ),
                    ),
                    // Language toggle top-right
                    Positioned(
                      top: 12,
                      right: 12,
                      child: const LanguageToggle(compact: true),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Loading animation
                      SafeLottie(
                        asset: 'assets/animations/loading.json',
                        height: 60,
                        repeat: true,
                      ),

                      // App name
                      ShaderMask(
                        shaderCallback: (b) =>
                            KColors.neonGradient.createShader(b),
                        child: const Text(
                          '梦行',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.appTagline,
                        style: const TextStyle(
                          color: KColors.accent,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // ── Login card ──────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: kuroCard(radius: 24, glow: true),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.welcomeBack,
                                  style: const TextStyle(
                                    color: KColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  )),
                              const SizedBox(height: 4),
                              Text(s.signInSubtitle,
                                  style: const TextStyle(
                                      color: KColors.textSecondary,
                                      fontSize: 13)),
                              const SizedBox(height: 20),

                              // Email
                              KuroTextField(
                                controller: _emailCtrl,
                                hint: s.email,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return s.emailRequired;
                                  if (!v.contains('@')) return s.emailInvalid;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Password
                              KuroTextField(
                                controller: _passwordCtrl,
                                hint: s.password,
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onToggleObscure: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                                onSubmitted: (_) => _signIn(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return s.passwordRequired;
                                  if (v.length < 6) return s.passwordTooShort;
                                  return null;
                                },
                              ),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.push(AppRoutes.forgotPassword),
                                  child: Text(s.forgotPassword,
                                      style: const TextStyle(
                                          color: KColors.accent, fontSize: 13)),
                                ),
                              ),

                              // Sign In
                              KuroButton(
                                label: s.signIn,
                                onPressed: _signIn,
                                isLoading: _isLoading,
                              ),
                              const SizedBox(height: 20),

                              KuroDivider(label: s.orContinueWith),
                              const SizedBox(height: 16),

                              // Google
                              KuroGoogleButton(
                                onPressed: _isLoading ? null : _googleSignIn,
                                isLoading: _isLoading,
                              ),
                              const SizedBox(height: 24),

                              // Register
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(s.noAccount,
                                        style: const TextStyle(
                                            color: KColors.textSecondary,
                                            fontSize: 14)),
                                    GestureDetector(
                                      onTap: () => context.push(AppRoutes.register),
                                      child: Text(s.signUp,
                                          style: const TextStyle(
                                            color: KColors.accent,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Language toggle (full)
                      const LanguageToggle(),
                      const SizedBox(height: 20),

                      KuroSparkleRow(text: s.stayMagical),
                      const SizedBox(height: 12),
                      // Kuromi peeking from corner
                      Align(
                        alignment: Alignment.centerRight,
                        child: KuroImage(
                          asset: KuromiAssets.peek,
                          width: 70,
                          height: 70,
                          fallbackEmoji: '🖤',
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
