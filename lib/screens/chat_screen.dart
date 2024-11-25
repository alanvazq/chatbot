import 'package:chatbot/entities/message.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/widgets/gemini_message_bubble.dart';
import 'package:chatbot/widgets/loading_message.dart';
import 'package:chatbot/widgets/message_bubble.dart';
import 'package:chatbot/widgets/message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          // child: CircleAvatar(
          //   // backgroundColor: Colors.white,
          //   // backgroundImage: AssetImage('assets/images/gemini.jpg'),
          // ),
        ),
        title: const Text("My Chat Bot"),
        centerTitle: true,
      ),
      body: const ChatView(),
    );
  }
}

class ChatView extends ConsumerWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: chatState.isLoadingChat
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller:
                        ref.read(chatProvider.notifier).chatScrollController,
                    itemCount: chatState.messageList.length +
                        (chatState.isWritingBot ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (chatState.isWritingBot &&
                          index == chatState.messageList.length) {
                        return const LoadingMessage();
                      }

                      final message = chatState.messageList[index];
                      return (message.fromWho == FromWho.gemini)
                          ? GeminiMessageBubble(message: message)
                          : MessageBubble(message: message);
                    },
                  ),
          ),
          const MessageField(),
        ],
      ),
    );
  }
}
