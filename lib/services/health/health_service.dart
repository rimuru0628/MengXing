import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/utils/date_utils.dart';

class HealthService {
  // health v10+ uses Health singleton
  final Health _health = Health();

  static const List<HealthDataType> _readTypes = [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.EXERCISE_TIME,
  ];

  bool _isAuthorized = false;
  bool get isAuthorized => _isAuthorized;

  /// Request health permissions. Returns true if granted.
  Future<bool> requestPermissions() async {
    try {
      // Activity recognition permission (Android)
      await Permission.activityRecognition.request();

      _isAuthorized = await _health.requestAuthorization(_readTypes);
      return _isAuthorized;
    } catch (e) {
      return false;
    }
  }

  /// Check if already authorized
  Future<bool> checkAuthorization() async {
    try {
      _isAuthorized = await _health.requestAuthorization(_readTypes);
      return _isAuthorized;
    } catch (e) {
      return false;
    }
  }

  /// Get today's step count from Health API
  Future<int?> getTodaySteps() async {
    if (!_isAuthorized) return null;
    try {
      final now = DateTime.now();
      final midnight = AppDateUtils.startOfDay(now);
      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps;
    } catch (e) {
      return null;
    }
  }

  /// Get step count for a specific date
  Future<int?> getStepsForDate(DateTime date) async {
    if (!_isAuthorized) return null;
    try {
      final start = AppDateUtils.startOfDay(date);
      final end = AppDateUtils.endOfDay(date);
      return await _health.getTotalStepsInInterval(start, end);
    } catch (e) {
      return null;
    }
  }

  /// Get walking/running distance (km) for today
  Future<double?> getTodayDistance() async {
    if (!_isAuthorized) return null;
    try {
      final now = DateTime.now();
      final midnight = AppDateUtils.startOfDay(now);
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.DISTANCE_WALKING_RUNNING],
      );
      if (data.isEmpty) return null;
      double total = 0;
      for (final point in data) {
        total += (point.value as NumericHealthValue).numericValue.toDouble();
      }
      return total / 1000.0; // meters → km
    } catch (e) {
      return null;
    }
  }

  /// Get active energy burned today (kcal)
  Future<double?> getTodayActiveCalories() async {
    if (!_isAuthorized) return null;
    try {
      final now = DateTime.now();
      final midnight = AppDateUtils.startOfDay(now);
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );
      if (data.isEmpty) return null;
      double total = 0;
      for (final point in data) {
        total += (point.value as NumericHealthValue).numericValue.toDouble();
      }
      return total;
    } catch (e) {
      return null;
    }
  }

  /// Get exercise minutes for today
  Future<int?> getTodayActiveMinutes() async {
    if (!_isAuthorized) return null;
    try {
      final now = DateTime.now();
      final midnight = AppDateUtils.startOfDay(now);
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.EXERCISE_TIME],
      );
      if (data.isEmpty) return null;
      double total = 0;
      for (final point in data) {
        total += (point.value as NumericHealthValue).numericValue.toDouble();
      }
      return total.round();
    } catch (e) {
      return null;
    }
  }

  /// Fetch all health data for today (convenience method)
  Future<DailyHealthData> getTodayHealthData() async {
    final steps = await getTodaySteps();
    final distanceKm = await getTodayDistance();
    final calories = await getTodayActiveCalories();
    final activeMinutes = await getTodayActiveMinutes();
    return DailyHealthData(
      steps: steps ?? 0,
      distanceKm: distanceKm ?? 0.0,
      calories: calories ?? 0.0,
      activeMinutes: activeMinutes ?? 0,
    );
  }
}

class DailyHealthData {
  final int steps;
  final double distanceKm;
  final double calories;
  final int activeMinutes;

  const DailyHealthData({
    required this.steps,
    required this.distanceKm,
    required this.calories,
    required this.activeMinutes,
  });
}
