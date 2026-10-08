import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'kuromi_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.infoLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFFFFEDD5),
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.accent,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.successLight,
      onTertiaryContainer: Color(0xFF065F46),
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: Color(0xFF7F1D1D),
      background: AppColors.backgroundLight,
      onBackground: AppColors.black,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.black,
      surfaceVariant: AppColors.grey100,
      onSurfaceVariant: AppColors.grey600,
      outline: AppColors.grey300,
      outlineVariant: AppColors.grey200,
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: AppColors.grey800,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.primaryLight,
    );    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: _buildTextTheme(AppColors.black),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.black),
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.infoLight,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600);
          }
          return AppTextStyles.labelSmall.copyWith(color: AppColors.grey500);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.grey500, size: 24);
        }),
        elevation: 8,
        shadowColor: Colors.black12,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 70,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        space: 1,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        labelStyle: AppTextStyles.labelMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        modalElevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.grey200,
      ),
      iconTheme: const IconThemeData(color: AppColors.grey700),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.black,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.black,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.accentLight,
      onTertiary: AppColors.black,
      tertiaryContainer: Color(0xFF065F46),
      onTertiaryContainer: AppColors.accentLight,
      error: Color(0xFFF87171),
      onError: AppColors.black,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFECACA),
      background: AppColors.backgroundDark,
      onBackground: AppColors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.white,
      surfaceVariant: AppColors.grey800,
      onSurfaceVariant: AppColors.grey400,
      outline: AppColors.grey700,
      outlineVariant: AppColors.grey800,
      shadow: Colors.black54,
      scrim: Colors.black87,
      inverseSurface: AppColors.grey100,
      onInverseSurface: AppColors.black,
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: _buildTextTheme(AppColors.white),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.grey900,
        indicatorColor: AppColors.primaryDark.withOpacity(0.3),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTextStyles.labelSmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600);
          }
          return AppTextStyles.labelSmall.copyWith(color: AppColors.grey400);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight, size: 24);
          }
          return const IconThemeData(color: AppColors.grey400, size: 24);
        }),
        elevation: 8,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 70,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey800,
        space: 1,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey800,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.grey900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        modalElevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        linearTrackColor: AppColors.grey700,
      ),
      iconTheme: const IconThemeData(color: AppColors.grey300),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: color),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: color),
      displaySmall: AppTextStyles.headlineLarge.copyWith(color: color),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: color),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: color),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: color),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: color),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: color),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: color.withOpacity(0.7)),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: color),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: color),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: color.withOpacity(0.7)),
    );
  }
}
