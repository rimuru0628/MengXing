import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String toDateKey(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static DateTime fromDateKey(String key) =>
      DateFormat('yyyy-MM-dd').parse(key);

  static String formatDate(DateTime date) =>
      DateFormat('MMM d, yyyy').format(date);

  static String formatTime(DateTime date) =>
      DateFormat('h:mm a').format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('MMM d, h:mm a').format(date);

  static String formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  static String formatDurationMinutes(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  static DateTime startOfWeek(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    return startOfDay(date.subtract(Duration(days: weekday - 1)));
  }

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  static List<DateTime> daysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = startOfDay(start);
    while (!current.isAfter(startOfDay(end))) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  static String relativeDay(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isYesterday(date)) return 'Yesterday';
    return formatDate(date);
  }

  static String weekdayShort(DateTime date) =>
      DateFormat('EEE').format(date);

  static String monthShort(DateTime date) =>
      DateFormat('MMM').format(date);
}
