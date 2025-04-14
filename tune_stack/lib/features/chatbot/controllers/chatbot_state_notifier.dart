import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/chatbot/controllers/chatbot_state.dart';
import 'package:tune_stack/features/chatbot/models/chat_message.dart';
import 'package:tune_stack/features/chatbot/repository/chatbot_repository.dart';

final chatbotStateNotifierProvider =
    StateNotifierProvider<ChatbotStateNotifier, ChatbotState>(
  (ref) => ChatbotStateNotifier(
    chatbotRepository: ChatbotRepository(
      apiKey: 'ENTER_YOUR_OPENAI_API_KEY', // Store this securely
    ),
  ),
);

class ChatbotStateNotifier extends StateNotifier<ChatbotState> {
  final ChatbotRepository chatbotRepository;

  ChatbotStateNotifier({
    required this.chatbotRepository,
  }) : super(ChatbotState.initial());

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(message: message, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // Get bot response
      final response = await chatbotRepository.getChatResponse(message);
      final botMessage = ChatMessage(message: response, isUser: false);

      state = state.copyWith(
        messages: [...state.messages, botMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error (show toast or error message)
    }
  }
}
