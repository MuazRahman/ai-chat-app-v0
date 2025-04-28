import 'package:ai_chat_app/app.dart';
import 'package:ai_chat_app/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ChatController());
  runApp(const ChatApp());
}