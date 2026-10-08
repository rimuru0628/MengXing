import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;
  final Color? color;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final btn = outlined
        ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: child)
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: color != null
                ? ElevatedButton.styleFrom(backgroundColor: color)
                : null,
            child: child,
          );

    if (width != null) {
      return SizedBox(width: width, child: btn);
    }
    return SizedBox(width: double.infinity, child: btn);
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color ?? Theme.of(context).colorScheme.onSurface),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
