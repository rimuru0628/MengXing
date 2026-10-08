import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services_providers.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final storage = ref.read(localStorageProvider);
  final saved = storage.themeMode;
  ThemeMode initial;
  switch (saved) {
    case 'light':
      initial = ThemeMode.light;
      break;
    case 'dark':
      initial = ThemeMode.dark;
      break;
    default:
      initial = ThemeMode.system;
  }
  return ThemeModeNotifier(ref, initial);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;

  ThemeModeNotifier(this._ref, ThemeMode initial) : super(initial);

  void setTheme(ThemeMode mode) {
    state = mode;
    String key;
    switch (mode) {
      case ThemeMode.light:
        key = 'light';
        break;
      case ThemeMode.dark:
        key = 'dark';
        break;
      default:
        key = 'system';
    }
    _ref.read(localStorageProvider).setThemeMode(key);
  }

  void toggle() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
