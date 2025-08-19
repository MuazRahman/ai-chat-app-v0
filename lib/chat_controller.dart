import 'package:ai_chat_app/generated/system_prompt_messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import 'message_model.dart';

class ChatController extends GetxController {
  final _messages = <Message>[].obs;
  final _textController = TextEditingController();
  final _isLoading = true.obs;
  late final ApiService _apiService;

  bool _initialized = false;
  bool _systemPromptSent = false;

  final List<Map<String, String>> _systemPrompt = [
    {
      "role": "system",
      "content": SystemPromptMessages.promptMessages
    }
  ];

  List<Message> get messages => _messages;
  TextEditingController get textController => _textController;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _initializeApiService();
  }

  Future<void> _initializeApiService() async {
    try {
      _apiService = ApiService();
      await _apiService.initialize();
      
      _messages.add(
        Message(
          text: "Hi, I'm MuazAI.👋 Your AI Assistant 🤖",
          isMe: false,
        ),
      );
      _initialized = true;
    } catch (e) {
      _messages.add(
        Message(
          text: "Failed to initialize. Please check your configuration.",
          isMe: false,
        ),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    if (!_initialized) return;

    final messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      _messages.add(Message(text: messageText, isMe: true));
      _textController.clear();

      final List<Map<String, String>> history = [];
      if (!_systemPromptSent) {
        history.addAll(_systemPrompt);
        _systemPromptSent = true;
      }

      final response = await _apiService.getResponseFromHistory(
        userMessages: _messages,
        systemPrompt: history,
      );

      _messages.add(Message(text: response, isMe: false));
    }
  }

  @override
  void onClose() {
    _textController.dispose();
    super.onClose();
  }
}
