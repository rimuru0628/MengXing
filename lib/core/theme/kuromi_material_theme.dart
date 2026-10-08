import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kuromi_theme.dart';
import 'app_text_styles.dart';

/// Full Material 3 theme built on the Kuromi palette.
/// Used as the primary (dark) theme of the app.
class KuroMaterialTheme {
  KuroMaterialTheme._();

  static ThemeData theme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: KColors.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF3D1270),
      onPrimaryContainer: KColors.neonPurple,
      secondary: KColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF5A0E3A),
      onSecondaryContainer: KColors.accent,
      tertiary: KColors.neonBlue,
      onTertiary: KColors.bg,
      tertiaryContainer: Color(0xFF0A2A3A),
      onTertiaryContainer: KColors.neonBlue,
      error: KColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFF5A0E1A),
      onErrorContainer: Color(0xFFFFB3C1),
      background: KColors.bg,
      onBackground: KColors.textPrimary,
      surface: KColors.card,
      onSurface: KColors.textPrimary,
      surfaceVariant: KColors.cardLight,
      onSurfaceVariant: KColors.textSecondary,
      outline: KColors.border,
      outlineVariant: KColors.divider,
      shadow: Colors.black87,
      scrim: Colors.black87,
      inverseSurface: KColors.textPrimary,
      onInverseSurface: KColors.bg,
      inversePrimary: KColors.primaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: KColors.bg,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: KColors.bg,
        foregroundColor: KColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
            color: KColors.textPrimary),
      ),
      // Cards
      cardTheme: CardThemeData(
        color: KColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KColors.primary,
          side: const BorderSide(color: KColors.primary, width: 1.5),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: KColors.accent,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: KColors.border.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: KColors.border.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: KColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: KColors.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: KColors.textSecondary),
        hintStyle: TextStyle(color: KColors.textHint),
      ),
      // Bottom nav
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: KColors.bg,
        indicatorColor: KColors.primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(
                color: KColors.accent, fontWeight: FontWeight.w700);
          }
          return AppTextStyles.labelSmall
              .copyWith(color: KColors.textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: KColors.accent, size: 24);
          }
          return const IconThemeData(
              color: KColors.textSecondary, size: 24);
        }),
        elevation: 8,
        shadowColor: Colors.black54,
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
        height: 70,
      ),
      // Divider
      dividerTheme: const DividerThemeData(
        color: KColors.divider,
        space: 1,
        thickness: 1,
      ),
      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: KColors.cardLight,
        labelStyle: AppTextStyles.labelMedium
            .copyWith(color: KColors.textPrimary),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: KColors.card,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
        ),
        modalElevation: 8,
      ),
      // Snack bar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: KColors.card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        contentTextStyle: AppTextStyles.bodyMedium
            .copyWith(color: KColors.textPrimary),
      ),
      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: KColors.primary,
        linearTrackColor: KColors.divider,
      ),
      // Icons
      iconTheme: const IconThemeData(color: KColors.textSecondary),
      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: KColors.card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTextStyles.titleLarge
            .copyWith(color: KColors.textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium
            .copyWith(color: KColors.textSecondary),
      ),
      // Tab bar
      tabBarTheme: TabBarThemeData(
        labelColor: KColors.accent,
        unselectedLabelColor: KColors.textSecondary,
        indicatorColor: KColors.accent,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 13),
      ),
      // List tile
      listTileTheme: const ListTileThemeData(
        iconColor: KColors.primary,
        textColor: KColors.textPrimary,
        subtitleTextStyle:
            TextStyle(color: KColors.textSecondary, fontSize: 12),
      ),
      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? KColors.accent
                : KColors.textSecondary),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? KColors.accent.withOpacity(0.3)
                : KColors.divider),
      ),
    );
  }
}
