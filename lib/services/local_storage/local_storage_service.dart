import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── Onboarding ───────────────────────────────────────────────────
  bool get onboardingDone => _prefs.getBool(AppConstants.keyOnboardingDone) ?? false;
  Future<void> setOnboardingDone() =>
      _prefs.setBool(AppConstants.keyOnboardingDone, true);

  // ─── Theme ────────────────────────────────────────────────────────
  String get themeMode => _prefs.getString(AppConstants.keyThemeMode) ?? 'system';
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(AppConstants.keyThemeMode, mode);

  // ─── Units ────────────────────────────────────────────────────────
  String get units => _prefs.getString(AppConstants.keyUnits) ?? 'metric';
  Future<void> setUnits(String units) =>
      _prefs.setString(AppConstants.keyUnits, units);

  // ─── Last sync ────────────────────────────────────────────────────
  String? get lastSyncDate => _prefs.getString(AppConstants.keyLastSyncDate);
  Future<void> setLastSyncDate(String date) =>
      _prefs.setString(AppConstants.keyLastSyncDate, date);

  // ─── Pending offline activity ─────────────────────────────────────
  int get pendingSteps => _prefs.getInt(AppConstants.keyPendingSteps) ?? 0;
  double get pendingDistance =>
      _prefs.getDouble(AppConstants.keyPendingDistance) ?? 0.0;
  int get pendingActiveMinutes =>
      _prefs.getInt(AppConstants.keyPendingActiveMinutes) ?? 0;

  Future<void> storePendingActivity({
    required int steps,
    required double distanceKm,
    required int activeMinutes,
  }) async {
    await _prefs.setInt(AppConstants.keyPendingSteps, steps);
    await _prefs.setDouble(AppConstants.keyPendingDistance, distanceKm);
    await _prefs.setInt(AppConstants.keyPendingActiveMinutes, activeMinutes);
  }

  Future<void> clearPendingActivity() async {
    await _prefs.remove(AppConstants.keyPendingSteps);
    await _prefs.remove(AppConstants.keyPendingDistance);
    await _prefs.remove(AppConstants.keyPendingActiveMinutes);
  }

  bool get hasPendingActivity => pendingSteps > 0;

  // ─── Generic helpers ─────────────────────────────────────────────
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<void> remove(String key) => _prefs.remove(key);
  Future<void> clear() => _prefs.clear();
}
