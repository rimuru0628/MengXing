import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/widgets/lottie_widget.dart';
import '../../../shared/widgets/lottie_widget.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/kuromi_theme.dart';
import '../../../shared/widgets/kuro_widgets.dart';
import '../../../shared/widgets/kuromi_image.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordReset(_emailCtrl.text.trim());
    if (!mounted) return;
    setState(() => _isLoading = false);
    final state = ref.read(authNotifierProvider);
    if (state is AsyncError) {
      context.showErrorSnackBar(
          'Could not send reset email. Please try again.');
    } else {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.bg,
      appBar: AppBar(
        backgroundColor: KColors.bg,
        elevation: 0,
        leading: BackButton(color: KColors.accent),
        title: const Text(
          'Reset Password',
          style: TextStyle(
              color: KColors.textPrimary, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _sent ? _buildSuccess() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: KColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: KColors.primary.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.lock_reset_rounded,
                  color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 28),
          ShaderMask(
            shaderCallback: (b) =>
                KColors.neonGradient.createShader(b),
            child: const Text(
              'Forgot your\npassword? 🔮',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "No worries! Enter your email and we'll send you a reset link.",
            style: TextStyle(
              color: KColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: kuroCard(radius: 20, glow: true),
            child: Column(
              children: [
                KuroTextField(
                  controller: _emailCtrl,
                  hint: 'Your email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _send(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                KuroButton(
                  label: 'Send Reset Link',
                  onPressed: _send,
                  isLoading: _isLoading,
                  icon: Icons.send_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success Lottie
        // Kuromi blush + Success Lottie side by side
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KuroImage(
              asset: KuromiAssets.blush,
              width: 90,
              height: 90,
              fallbackEmoji: '🌸',
            ),
            const SizedBox(width: 8),
            SafeLottie(
              asset: 'assets/animations/success.json',
              height: 90,
              width: 90,
              repeat: false,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (b) =>
              KColors.neonGradient.createShader(b),
          child: const Text(
            'Check your inbox! 💌',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a password reset link to\n${_emailCtrl.text}',
          style: const TextStyle(
            color: KColors.textSecondary,
            fontSize: 15,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        KuroButton(
          label: 'Back to Login',
          onPressed: () => context.pop(),
          icon: Icons.arrow_back_rounded,
        ),
        const SizedBox(height: 16),
        const KuroSparkleRow(text: 'You\'ve got this!'),
      ],
    );
  }
}
