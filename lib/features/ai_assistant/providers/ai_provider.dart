import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/ai/ai_service.dart';
import '../../../shared/providers/services_providers.dart';
import '../../home/providers/home_provider.dart';
import '../../profile/providers/profile_provider.dart';

final aiMessagesProvider =
    StateNotifierProvider<AiMessagesNotifier, List<AiMessage>>(
        (ref) => AiMessagesNotifier(ref));

class AiMessagesNotifier extends StateNotifier<List<AiMessage>> {
  final Ref _ref;

  AiMessagesNotifier(this._ref) : super([
    AiMessage(
      role: 'assistant',
      content: 'Hi! I\'m your MengXing fitness assistant 🌟 Ask me anything about your workouts, walking goals, or fitness tips!',
      timestamp: DateTime.now(),
    ),
  ]);

  Future<void> sendMessage(String text) async {
    // Add user message
    state = [...state, AiMessage(role: 'user', content: text, timestamp: DateTime.now())];

    // Get context
    final profile = _ref.read(profileProvider).valueOrNull;
    final todayActivity = _ref.read(todayActivityProvider).valueOrNull;

    // Get AI response
    final ai = _ref.read(aiServiceProvider);
    final response = await ai.sendMessage(
      userMessage: text,
      history: state.take(state.length - 1).toList(),
      profile: profile,
      todayActivity: todayActivity,
    );

    state = [...state, AiMessage(role: 'assistant', content: response, timestamp: DateTime.now())];
  }

  void clearHistory() => state = [state.first]; // keep greeting
}

final aiLoadingProvider = StateProvider<bool>((ref) => false);
