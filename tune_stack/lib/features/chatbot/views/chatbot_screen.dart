import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/features/chatbot/controllers/chatbot_state_notifier.dart';
import 'package:tune_stack/features/chatbot/views/widgets/chat_bubble.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatbotState = ref.watch(chatbotStateNotifierProvider);
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const BackArrowAppBar(
        title: 'Music Assistant',
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatbotState.messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: chatbotState.messages[index],
                );
              },
            ),
          ),
          if (chatbotState.isLoading)
            const Padding(
              padding: EdgeInsets.all(AppConst.k8),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(AppConst.k16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask something about music...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                AppConst.gap12,
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final message = _messageController.text;
                    if (message.trim().isNotEmpty) {
                      _messageController.clear();
                      await ref
                          .read(chatbotStateNotifierProvider.notifier)
                          .sendMessage(message);
                      _scrollToBottom();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}