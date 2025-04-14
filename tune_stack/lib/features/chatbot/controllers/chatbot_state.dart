import 'package:tune_stack/features/chatbot/models/chat_message.dart';

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatbotState({
    required this.messages,
    required this.isLoading,
  });

  ChatbotState.initial()
      : messages = [],
        isLoading = false;

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}