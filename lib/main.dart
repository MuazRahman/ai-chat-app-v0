import 'package:ai_chat_app/app.dart';
import 'package:ai_chat_app/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    Get.put(ChatController());
    runApp(const ChatApp());
  } catch (e) {
    // Fallback app if initialization fails
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app: $e'),
        ),
      ),
    ));
  }
}