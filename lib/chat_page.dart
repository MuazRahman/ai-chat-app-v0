import 'package:ai_chat_app/assets_path.dart';
import 'package:ai_chat_app/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), // 0.4 = 40% dark
              BlendMode.darken,
            ),
            child: Image.asset(
              AssetsPath.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text('AI Chat Assistant', style: TextStyle(fontWeight: FontWeight.w600),),backgroundColor: Colors.white,),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                      () => ListView.builder(
                    itemCount: _chatController.messages.length,
                    itemBuilder: (context, index) {
                      final message = _chatController.messages[index];
                      return Align(
                        alignment:
                        message.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: message.isMe ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController.textController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          fillColor: Colors.white, filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          ),
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400)
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _chatController.sendMessage,
                      child: Text('Send', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }
}
