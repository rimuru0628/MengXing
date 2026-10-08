import 'package:cloud_firestore/cloud_firestore.dart';

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final int totalDaysCompleted;
  final DateTime? lastActivityDate;
  final List<String> completedDates; // yyyy-MM-dd keys

  const StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalDaysCompleted = 0,
    this.lastActivityDate,
    this.completedDates = const [],
  });

  factory StreakData.fromFirestore(Map<String, dynamic> data) => StreakData(
        currentStreak: data['currentStreak'] ?? 0,
        longestStreak: data['longestStreak'] ?? 0,
        totalDaysCompleted: data['totalDaysCompleted'] ?? 0,
        lastActivityDate: data['lastActivityDate'] != null
            ? (data['lastActivityDate'] as Timestamp).toDate()
            : null,
        completedDates: List<String>.from(data['completedDates'] ?? []),
      );

  Map<String, dynamic> toFirestore() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'totalDaysCompleted': totalDaysCompleted,
        'lastActivityDate': lastActivityDate != null
            ? Timestamp.fromDate(lastActivityDate!)
            : null,
        'completedDates': completedDates,
      };
}
