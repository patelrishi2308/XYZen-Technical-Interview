import 'package:dart_openai/dart_openai.dart';

class ChatbotRepository {
  final String apiKey;

  ChatbotRepository({required this.apiKey}) {
    OpenAI.apiKey = apiKey;
  }

  Future<String> getChatResponse(String message) async {
    try {
      final completion = await OpenAI.instance.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                'You are a music expert assistant. Answer questions about music, artists, and the music industry.',
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                message,
              ),
            ],
          ),
        ],
      );

      final content = completion.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('No response from OpenAI');
      }

      return content.first.text ?? '';
    } catch (e) {
      throw Exception('Failed to get chat response: $e');
    }
  }
}
