import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import 'message_model.dart';

class ChatController extends GetxController {
  final _messages = <Message>[].obs;
  final _textController = TextEditingController();

  List<Message> get messages => _messages.value;

  TextEditingController get textController => _textController;

  void sendMessage() async {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      _messages.add(Message(text: message, isMe: true));
      _textController.clear();
      final response = await ApiService().getResponse(message);
      _messages.add(Message(text: response, isMe: false));
    }
  }
}