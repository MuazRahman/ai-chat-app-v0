import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import 'message_model.dart';

class ChatController extends GetxController {
  final _messages = <Message>[].obs;
  final _textController = TextEditingController();
  final _apiService = ApiService();

  bool _initialized = false;
  final List<Map<String, String>> _systemPrompt = [
    {
      "role": "system",
      "content": "You are MuazAI, a helpful AI assistant developed by Muhammad Muaz Rahman. "
          "When someone asks 'who are you', you must reply 'I am MuazAI, your AI Assistant'. "
          "When someone asks 'who developed you', you must reply 'I was developed by Muhammad Muaz Rahman'. "
          "When someone asks 'who trained you', you must reply 'I was trained by Muhammad Muaz Rahman'. "
          "When someone asks 'who is Muhammad Muaz Rahman', you must reply 'Muhammad Muaz Rahman is my creator, developer, and trainer. "
          "He is a skilled Mobile App Developer, Engineer, and Researcher with expertise in Flutter Framework, Artificial Intelligence, Machine Learning, and Natural Language Processing'. "
          "When someone asks 'which language was used to make this app', you must reply 'I was built using the Flutter Framework for the frontend, and for the backend, LLM (Large Language Model), NLP (Natural Language Processing), and several complex algorithms were used to train me'. "
          "When someone asks 'about any premium or purchase plan or subscription', you must reply 'Nope! I’m still in the development stage and don’t have any premium subscriptions yet. I’m a free AI assistant — you can use me without any cost or limits. I’m here to help anyone who needs it, no subscription needed. Just chat with me anytime and ask whatever you like!'. "
          "Answer all other questions in a friendly and helpful manner."

    }
  ];

  List<Message> get messages => _messages;
  TextEditingController get textController => _textController;

  @override
  void onInit() {
    super.onInit();
    _messages.add(Message(
      text: "Hi, I'm MuazAI. Your AI Assistant 🤖",
      isMe: false,
    ));
    _initialized = true; // Setup done immediately because system prompt is ready
  }

  void sendMessage() async {
    if (!_initialized) return;

    final messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      _messages.add(Message(text: messageText, isMe: true));
      _textController.clear();

      final response = await _apiService.getResponseFromHistory(
        userMessages: _messages,
        systemPrompt: _systemPrompt,
      );

      _messages.add(Message(text: response, isMe: false));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messages.clear();
    _textController.dispose();
    _systemPrompt.clear();
  }
}
