import 'package:cloud_firestore/cloud_firestore.dart';

enum ChallengeType { daily, weekly, monthly }

enum ChallengeStatus { notStarted, inProgress, completed, failed }

class Challenge {
  final String challengeId;
  final String title;
  final String description;
  final ChallengeType type;
  final ChallengeStatus status;
  final double targetValue;
  final double currentValue;
  final String unit;
  final DateTime startDate;
  final DateTime endDate;
  final String emoji;

  const Challenge({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.type,
    this.status = ChallengeStatus.notStarted,
    required this.targetValue,
    this.currentValue = 0.0,
    required this.unit,
    required this.startDate,
    required this.endDate,
    this.emoji = '🏆',
  });

  double get progress => targetValue > 0
      ? (currentValue / targetValue).clamp(0.0, 1.0)
      : 0.0;

  bool get isCompleted => currentValue >= targetValue;
  bool get isExpired => DateTime.now().isAfter(endDate);

  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Challenge(
      challengeId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: ChallengeType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => ChallengeType.daily,
      ),
      status: ChallengeStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => ChallengeStatus.notStarted,
      ),
      targetValue: (data['targetValue'] as num?)?.toDouble() ?? 0.0,
      currentValue: (data['currentValue'] as num?)?.toDouble() ?? 0.0,
      unit: data['unit'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      emoji: data['emoji'] ?? '🏆',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'type': type.name,
        'status': status.name,
        'targetValue': targetValue,
        'currentValue': currentValue,
        'unit': unit,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'emoji': emoji,
      };

  Challenge copyWith({double? currentValue, ChallengeStatus? status}) =>
      Challenge(
        challengeId: challengeId,
        title: title,
        description: description,
        type: type,
        status: status ?? this.status,
        targetValue: targetValue,
        currentValue: currentValue ?? this.currentValue,
        unit: unit,
        startDate: startDate,
        endDate: endDate,
        emoji: emoji,
      );
}
