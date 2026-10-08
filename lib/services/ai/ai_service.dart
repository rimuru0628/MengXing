import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../shared/models/daily_activity.dart';
import '../../shared/models/user_profile.dart';

class AiMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime timestamp;

  const AiMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });
}

class AiService {
  // Replace with your OpenAI-compatible API key and endpoint
  // For production, use Firebase Remote Config or Cloud Functions to store the key
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  String? _apiKey;

  void setApiKey(String key) => _apiKey = key;

  Future<String> sendMessage({
    required String userMessage,
    required List<AiMessage> history,
    UserProfile? profile,
    DailyActivity? todayActivity,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return _fallbackResponse(userMessage);
    }

    final contextInfo = _buildContext(profile, todayActivity);
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': AppConstants.aiSystemPrompt +
            (contextInfo.isNotEmpty ? '\n\nUser context:\n$contextInfo' : ''),
      },
      // Keep last N messages for context
      ...history
          .take(AppConstants.aiMaxHistoryMessages)
          .map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': _model,
              'messages': messages,
              'max_tokens': 500,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        return 'Sorry, I\'m having trouble connecting right now. Please try again.';
      }
    } catch (e) {
      return _fallbackResponse(userMessage);
    }
  }

  String _buildContext(UserProfile? profile, DailyActivity? activity) {
    final buffer = StringBuffer();
    if (profile != null) {
      buffer.writeln('Name: ${profile.name}');
      if (profile.age != null) buffer.writeln('Age: ${profile.age}');
      if (profile.weightKg != null) buffer.writeln('Weight: ${profile.weightKg}kg');
      if (profile.heightCm != null) buffer.writeln('Height: ${profile.heightCm}cm');
      buffer.writeln('Fitness level: ${profile.fitnessLevel.name}');
      buffer.writeln('Goal: ${profile.fitnessGoal.name}');
      buffer.writeln('Daily step goal: ${profile.dailyStepGoal}');
    }
    if (activity != null) {
      buffer.writeln('\nToday\'s activity:');
      buffer.writeln('Steps: ${activity.steps}');
      buffer.writeln('Distance: ${activity.distanceKm.toStringAsFixed(1)}km');
      buffer.writeln('Active minutes: ${activity.activeMinutes}');
      buffer.writeln('Walks: ${activity.walkCount}');
      buffer.writeln('Workout completed: ${activity.workoutCompleted}');
    }
    return buffer.toString();
  }

  String _fallbackResponse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('motivat') || lower.contains('tired')) {
      return 'Every step counts! Remember, even a short 10-minute walk can boost your mood and energy. You\'ve got this! 💪';
    }
    if (lower.contains('warm up') || lower.contains('warmup')) {
      return 'A good warm-up should be 5–10 minutes of light movement — gentle arm circles, leg swings, and a slow walk. This prepares your muscles and reduces injury risk.';
    }
    if (lower.contains('squat')) {
      return 'For squats: stand with feet shoulder-width apart, push your hips back and down, keep your chest up and knees tracking over your toes. Aim for 3 sets of 10–15 reps.';
    }
    if (lower.contains('steps') || lower.contains('walk')) {
      return 'Walking is one of the best exercises! Try to spread your steps throughout the day — morning, lunchtime, and evening walks all add up.';
    }
    if (lower.contains('rest') || lower.contains('recovery')) {
      return 'Rest days are important for recovery and muscle growth. Try light stretching or a gentle walk on rest days to stay active without overexerting.';
    }
    return 'That\'s a great fitness question! For personalized advice, make sure to configure the AI service in settings. In the meantime, remember: consistency is the key to any fitness goal. 🌟';
  }

  /// Generate a daily activity summary
  Future<String> generateDailySummary({
    required DailyActivity activity,
    required UserProfile profile,
  }) async {
    final prompt = '''
Generate a brief, friendly summary (2-3 sentences) for this user's day:
- Steps: ${activity.steps} (goal: ${profile.dailyStepGoal})
- Distance: ${activity.distanceKm.toStringAsFixed(1)}km
- Active minutes: ${activity.activeMinutes}
- Walks: ${activity.walkCount}
- Workout completed: ${activity.workoutCompleted}

Be factual, encouraging, and mention what goals were met.
''';
    return sendMessage(userMessage: prompt, history: []);
  }

  /// Generate workout recommendation
  Future<String> generateWorkoutRecommendation(UserProfile profile) async {
    final prompt =
        'Suggest a ${profile.preferredWorkoutDurationMinutes}-minute workout for a ${profile.fitnessLevel.name} level person '
        'whose goal is ${profile.fitnessGoal.name}. Be specific with exercises, sets, and reps.';
    return sendMessage(userMessage: prompt, history: []);
  }
}
