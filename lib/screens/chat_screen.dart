import 'dart:async';
import 'package:chatbot/entities/message.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/widgets/gemini_message_bubble.dart';
import 'package:chatbot/widgets/message_bubble.dart';
import 'package:chatbot/widgets/message_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
        title: const Text("My Chat Bot"),
      ),
      body: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late StreamSubscription _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _loadConversation();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool connected = result != ConnectivityResult.none;

    setState(() {
      isConnected = connected;
    });

    if (!isConnected) {
      print('sin conexion');
    } else if (isConnected) {
      print('Con conexion');
    }
  }

  Future<void> _loadConversation() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadConversation();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(
              child: chatProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: chatProvider.chatScrollController,
                      itemCount: chatProvider.messageList.length,
                      itemBuilder: (context, index) {
                        final message = chatProvider.messageList[index];
                        return (message.fromWho == FromWho.gemini)
                            ? GeminiMessageBubble(
                                message: message,
                              )
                            : MessageBubble(
                                message: message,
                              );
                      })),
          MessageField(
            isConnected: isConnected,
          )
        ],
      ),
    );
  }
}
