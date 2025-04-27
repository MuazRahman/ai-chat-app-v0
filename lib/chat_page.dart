import 'package:ai_chat_app/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = Get.put(ChatController());
  final ScrollController _scrollController = Get.put(ScrollController());

  @override
  void initState() {
    super.initState();
    // Listen for changes and scroll to bottom
    ever(_chatController.messages as RxInterface<Object?>, (_) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;

    return Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(25), // withOpacity(0.4) = 40% dark
              BlendMode.darken,
            ),
            child: Image.asset(AssetsPath.backgroundImage, fit: BoxFit.cover),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('AI Chat Assistant')),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: _scrollController,
                    itemCount: _chatController.messages.length,
                    itemBuilder: (context, index) {
                      final message = _chatController.messages[index];
                      return Align(
                        alignment:
                            message.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                message.isMe
                                    ? Colors.black45.withAlpha(100)
                                    : Colors.grey.shade200.withAlpha(120),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SelectableText(
                            message.text,
                            style: TextStyle(
                              color: message.isMe ? Colors.white : Colors.black,
                              fontSize: message.isMe ? 15.5 : 16,
                              fontWeight: FontWeight.w500,
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
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                        ),
                        style: textStyle,
                        autocorrect: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _chatController.sendMessage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        // Adjust padding for size
                        backgroundColor: Colors.black38, // Button color
                      ),
                      child: Image.asset(AssetsPath.sendButtonIcon, width: 34),
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
