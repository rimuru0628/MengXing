import 'package:flutter/material.dart';
import '../../core/theme/kuromi_theme.dart';

// ─── Gradient button ──────────────────────────────────────────────────────────
class KuroButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final bool outlined;

  const KuroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 52,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: KColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            foregroundColor: KColors.textPrimary,
          ),
          child: _child(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: kuroButtonDecoration(),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: _child(),
        ),
      ),
    );
  }

  Widget _child() {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
            strokeWidth: 2.5, color: Colors.white),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: _textStyle()),
        ],
      );
    }
    return Text(label, style: _textStyle());
  }

  TextStyle _textStyle() => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 15,
        letterSpacing: 0.5,
      );
}

// ─── Google button ─────────────────────────────────────────────────────────────
class KuroGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const KuroGoogleButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: KColors.border.withOpacity(0.6), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: KColors.inputFill,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: KColors.primary),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('G',
                          style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          )),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Continue with Google',
                      style: TextStyle(
                        color: KColors.textPrimary.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                ],
              ),
      ),
    );
  }
}

// ─── Text input field ─────────────────────────────────────────────────────────
class KuroTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final TextCapitalization capitalization;

  const KuroTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.validator,
    this.onSubmitted,
    this.textInputAction,
    this.capitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: capitalization,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(color: KColors.textPrimary, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: KColors.textHint.withOpacity(0.8), fontSize: 14),
        filled: true,
        fillColor: KColors.inputFill,
        prefixIcon: Icon(icon, color: KColors.primary, size: 20),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: KColors.primary.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: KColors.border.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: KColors.border.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: KColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: KColors.accent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: KColors.accent, width: 2),
        ),
        errorStyle:
            const TextStyle(color: KColors.accent, fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
    );
  }
}

// ─── Section title ─────────────────────────────────────────────────────────────
class KuroSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const KuroSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: KColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        if (action != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                color: KColors.accent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Stat chip ────────────────────────────────────────────────────────────────
class KuroStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const KuroStatChip({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: KColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────
class KuroDivider extends StatelessWidget {
  final String? label;
  const KuroDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Divider(
          color: KColors.divider, height: 1, thickness: 1);
    }
    return Row(
      children: [
        Expanded(
            child: Divider(color: KColors.border.withOpacity(0.4))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label!,
              style: const TextStyle(
                  color: KColors.textHint, fontSize: 13)),
        ),
        Expanded(
            child: Divider(color: KColors.border.withOpacity(0.4))),
      ],
    );
  }
}

// ─── Sparkle decoration ───────────────────────────────────────────────────────
class KuroSparkleRow extends StatelessWidget {
  final String text;
  const KuroSparkleRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('✦',
            style: TextStyle(color: KColors.accent, fontSize: 13)),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: KColors.textHint, fontSize: 12)),
        const SizedBox(width: 8),
        const Text('✦',
            style: TextStyle(color: KColors.neonBlue, fontSize: 13)),
      ],
    );
  }
}
