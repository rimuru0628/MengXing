import '../constants/app_constants.dart';

class FitnessUtils {
  FitnessUtils._();

  /// Estimate distance from steps using a default or height-based stride length
  static double stepsToKm(int steps, {double? heightCm}) {
    final strideM = heightCm != null ? heightCm * 0.0041 : AppConstants.defaultStepLengthM;
    return (steps * strideM) / 1000.0;
  }

  /// Estimate steps from distance
  static int kmToSteps(double km, {double? heightCm}) {
    final strideM = heightCm != null ? heightCm * 0.0041 : AppConstants.defaultStepLengthM;
    return (km * 1000 / strideM).round();
  }

  /// Estimate calories burned walking
  /// MET * weight(kg) * duration(hours)
  static double estimateCaloriesWalking({
    required double weightKg,
    required int durationSeconds,
    double met = AppConstants.metWalking,
  }) {
    final hours = durationSeconds / 3600.0;
    return met * weightKg * hours;
  }

  /// Simple calorie estimate from steps
  static double caloriesFromSteps(int steps, {double weightKg = 70}) {
    return steps * AppConstants.caloriesPerStep * (weightKg / 70.0);
  }

  /// Calculate pace (min/km) from duration and distance
  static double calculatePace(int durationSeconds, double distanceKm) {
    if (distanceKm <= 0) return 0;
    return (durationSeconds / 60.0) / distanceKm;
  }

  /// Format pace as "X:XX min/km"
  static String formatPace(double paceMinPerKm) {
    if (paceMinPerKm <= 0 || paceMinPerKm.isInfinite || paceMinPerKm.isNaN) {
      return '--:-- min/km';
    }
    final mins = paceMinPerKm.floor();
    final secs = ((paceMinPerKm - mins) * 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')} min/km';
  }

  /// BMI
  static double calculateBmi(double weightKg, double heightCm) {
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Goal progress percentage (0.0 – 1.0 clamped)
  static double goalProgress(num current, num goal) {
    if (goal <= 0) return 0;
    return (current / goal).clamp(0.0, 1.0).toDouble();
  }

  /// Format distance
  static String formatDistance(double km) {
    if (km < 1.0) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  /// Format steps with comma separator
  static String formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return steps.toString();
  }

  static String formatStepsFull(int steps) {
    final s = steps.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    return result.toString();
  }
}
