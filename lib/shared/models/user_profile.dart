import 'package:cloud_firestore/cloud_firestore.dart';

enum FitnessLevel { beginner, intermediate, advanced }

enum FitnessGoal {
  loseWeight,
  stayActive,
  buildEndurance,
  buildStrength,
  improveHealth,
  runFaster,
}

enum Gender { male, female, nonBinary, preferNotToSay }

class UserProfile {
  final String userId;
  final String name;
  final String? avatarUrl;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final Gender? gender;
  final FitnessLevel fitnessLevel;
  final FitnessGoal fitnessGoal;
  final List<String> preferredExerciseTypes;
  final int preferredWorkoutDurationMinutes;
  final List<String> availableEquipment;
  final int dailyStepGoal;
  final double dailyWalkingGoalKm;
  final int dailyActiveMinuteGoal;
  final int dailyWalkGoal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.age,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.fitnessLevel = FitnessLevel.beginner,
    this.fitnessGoal = FitnessGoal.stayActive,
    this.preferredExerciseTypes = const [],
    this.preferredWorkoutDurationMinutes = 30,
    this.availableEquipment = const ['none'],
    this.dailyStepGoal = 8000,
    this.dailyWalkingGoalKm = 5.0,
    this.dailyActiveMinuteGoal = 30,
    this.dailyWalkGoal = 3,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      userId: doc.id,
      name: data['name'] ?? '',
      avatarUrl: data['avatarUrl'],
      age: data['age'],
      heightCm: (data['heightCm'] as num?)?.toDouble(),
      weightKg: (data['weightKg'] as num?)?.toDouble(),
      gender: data['gender'] != null
          ? Gender.values.firstWhere(
              (g) => g.name == data['gender'],
              orElse: () => Gender.preferNotToSay,
            )
          : null,
      fitnessLevel: FitnessLevel.values.firstWhere(
        (l) => l.name == data['fitnessLevel'],
        orElse: () => FitnessLevel.beginner,
      ),
      fitnessGoal: FitnessGoal.values.firstWhere(
        (g) => g.name == data['fitnessGoal'],
        orElse: () => FitnessGoal.stayActive,
      ),
      preferredExerciseTypes:
          List<String>.from(data['preferredExerciseTypes'] ?? []),
      preferredWorkoutDurationMinutes:
          data['preferredWorkoutDurationMinutes'] ?? 30,
      availableEquipment:
          List<String>.from(data['availableEquipment'] ?? ['none']),
      dailyStepGoal: data['dailyStepGoal'] ?? 8000,
      dailyWalkingGoalKm: (data['dailyWalkingGoalKm'] as num?)?.toDouble() ?? 5.0,
      dailyActiveMinuteGoal: data['dailyActiveMinuteGoal'] ?? 30,
      dailyWalkGoal: data['dailyWalkGoal'] ?? 3,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'avatarUrl': avatarUrl,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'gender': gender?.name,
        'fitnessLevel': fitnessLevel.name,
        'fitnessGoal': fitnessGoal.name,
        'preferredExerciseTypes': preferredExerciseTypes,
        'preferredWorkoutDurationMinutes': preferredWorkoutDurationMinutes,
        'availableEquipment': availableEquipment,
        'dailyStepGoal': dailyStepGoal,
        'dailyWalkingGoalKm': dailyWalkingGoalKm,
        'dailyActiveMinuteGoal': dailyActiveMinuteGoal,
        'dailyWalkGoal': dailyWalkGoal,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  UserProfile copyWith({
    String? name,
    String? avatarUrl,
    int? age,
    double? heightCm,
    double? weightKg,
    Gender? gender,
    FitnessLevel? fitnessLevel,
    FitnessGoal? fitnessGoal,
    List<String>? preferredExerciseTypes,
    int? preferredWorkoutDurationMinutes,
    List<String>? availableEquipment,
    int? dailyStepGoal,
    double? dailyWalkingGoalKm,
    int? dailyActiveMinuteGoal,
    int? dailyWalkGoal,
  }) =>
      UserProfile(
        userId: userId,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        age: age ?? this.age,
        heightCm: heightCm ?? this.heightCm,
        weightKg: weightKg ?? this.weightKg,
        gender: gender ?? this.gender,
        fitnessLevel: fitnessLevel ?? this.fitnessLevel,
        fitnessGoal: fitnessGoal ?? this.fitnessGoal,
        preferredExerciseTypes:
            preferredExerciseTypes ?? this.preferredExerciseTypes,
        preferredWorkoutDurationMinutes: preferredWorkoutDurationMinutes ??
            this.preferredWorkoutDurationMinutes,
        availableEquipment: availableEquipment ?? this.availableEquipment,
        dailyStepGoal: dailyStepGoal ?? this.dailyStepGoal,
        dailyWalkingGoalKm: dailyWalkingGoalKm ?? this.dailyWalkingGoalKm,
        dailyActiveMinuteGoal:
            dailyActiveMinuteGoal ?? this.dailyActiveMinuteGoal,
        dailyWalkGoal: dailyWalkGoal ?? this.dailyWalkGoal,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
