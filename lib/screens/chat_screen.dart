import 'package:chatbot/entities/message.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/widgets/gemini_message_bubble.dart';
import 'package:chatbot/widgets/message_bubble.dart';
import 'package:chatbot/widgets/message_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/gemini.jpg'),
          ),
        ),
        title: const Text("Google Gemini IA"),
      ),
      body: ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {

    final chatProvider = context.watch<ChatProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(child: ListView.builder(
            controller: chatProvider.chatScrollController,
            itemCount: chatProvider.messageList.length,
            itemBuilder: (context, index) {
            final message = chatProvider.messageList[index];
            return ( message.fromWho == FromWho.gemini) ? GeminiMessageBubble(message: message,) : MessageBubble(message: message,);
          })),
          MessageField()
        ],
      ),
    );
  }
}
