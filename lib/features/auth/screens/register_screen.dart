import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref.read(authNotifierProvider.notifier).registerWithEmail(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);
    final state = ref.read(authNotifierProvider);
    if (state is AsyncError) {
      context.showErrorSnackBar(
          state.error.toString().replaceAll('Exception: ', ''));
    } else {
      context.go(AppRoutes.profileSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.bg,
      appBar: AppBar(
        backgroundColor: KColors.bg,
        foregroundColor: KColors.textPrimary,
        elevation: 0,
        leading: BackButton(
          color: KColors.accent,
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: KColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: KColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: KColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_add_rounded,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 8),
                      KuroImage(
                        asset: KuromiAssets.cute,
                        width: 80,
                        height: 80,
                        fallbackEmoji: '🌸',
                      ),
                      const SizedBox(height: 8),
                      ShaderMask(
                        shaderCallback: (b) =>
                            KColors.neonGradient.createShader(b),
                        child: const Text(
                          'Join MengXing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Start your fitness journey today ✨',
                        style: TextStyle(
                          color: KColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: kuroCard(radius: 24, glow: true),
                  child: Column(
                    children: [
                      KuroTextField(
                        controller: _nameCtrl,
                        hint: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        capitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      KuroTextField(
                        controller: _emailCtrl,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      KuroTextField(
                        controller: _passwordCtrl,
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePass,
                        textInputAction: TextInputAction.next,
                        onToggleObscure: () =>
                            setState(() => _obscurePass = !_obscurePass),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      KuroTextField(
                        controller: _confirmCtrl,
                        hint: 'Confirm Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        onToggleObscure: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        onSubmitted: (_) => _register(),
                        validator: (v) => v != _passwordCtrl.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      const SizedBox(height: 28),
                      KuroButton(
                        label: 'Create Account',
                        onPressed: _register,
                        isLoading: _isLoading,
                        icon: Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'By creating an account, you agree to our\nTerms of Service and Privacy Policy.',
                    style: TextStyle(
                      color: KColors.textHint,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const KuroSparkleRow(text: 'Stay active, stay magical'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
