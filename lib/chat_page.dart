import 'package:ai_chat_app/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();
  final RxBool _showScrollDownButton = false.obs;

  @override
  void initState() {
    super.initState();

    ever<List>(_chatController.messages as RxInterface<List>, (_) {
      _scrollToBottom();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset <
        _scrollController.position.maxScrollExtent - 300) {
      _showScrollDownButton.value = true;
    } else {
      _showScrollDownButton.value = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_chatController.textController.text.trim().isEmpty) return;
    await _chatController.sendMessage();
    // ❌ Removed typing simulation here
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall;

    return Stack(
      children: [
        Positioned.fill(
          child: Hero(
            tag: 'background',
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withAlpha(25),
                BlendMode.darken,
              ),
              child: Image.asset(
                AssetsPath.backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('MuazAI Chat Assistant'),
            centerTitle: true,
            backgroundColor: Colors.black26.withOpacity(0.3),
            elevation: 0,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Obx(
                          () => ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatController.messages.length,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final message = _chatController.messages[index];
                          return Align(
                            alignment: message.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: message.isMe
                                    ? Colors.blueGrey.withAlpha(120)
                                    : Colors.white.withAlpha(220),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.05),
                                    offset: const Offset(2, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: message.isMe
                                  ? SelectableText(
                                message.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                                  : MarkdownBody(
                                data: message.text,
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _buildInputBar(textStyle),
                ],
              ),
              Obx(
                    () => _showScrollDownButton.value
                    ? Positioned(
                  bottom: 90,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black54,
                    mini: true,
                    onPressed: _scrollToBottom,
                    child: const Icon(Icons.arrow_downward),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar(TextStyle? textStyle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController.textController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              style: textStyle,
              autocorrect: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}
