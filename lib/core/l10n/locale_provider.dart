import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_strings.dart';
import '../../shared/providers/services_providers.dart';

// ─── Locale notifier ──────────────────────────────────────────────────────────
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.read(localStorageProvider);
  final saved = storage.getString('app_locale') ?? 'en';
  return LocaleNotifier(
    ref,
    saved == 'zh' ? const Locale('zh') : const Locale('en'),
  );
});

class LocaleNotifier extends StateNotifier<Locale> {
  final Ref _ref;

  LocaleNotifier(this._ref, Locale initial) : super(initial);

  bool get isChinese => state.languageCode == 'zh';

  void setEnglish() {
    state = const Locale('en');
    _ref.read(localStorageProvider).setString('app_locale', 'en');
  }

  void setChinese() {
    state = const Locale('zh');
    _ref.read(localStorageProvider).setString('app_locale', 'zh');
  }

  void toggle() => isChinese ? setEnglish() : setChinese();
}

// ─── Strings provider ────────────────────────────────────────────────────────
final stringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeProvider);
  return AppStrings(isChinese: locale.languageCode == 'zh');
});

// ─── Convenience extension ───────────────────────────────────────────────────
extension StringsX on AppStrings {
  static AppStrings watch(WidgetRef ref) => ref.watch(stringsProvider);
}
