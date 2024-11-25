import 'dart:convert';

import 'package:chatbot/entities/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:chatbot/services/data_history_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatState {
  final List<Message> messageList;
  final bool isConnected;
  final bool isLoadingChat;
  final bool isWritingBot;

  ChatState(
      {this.messageList = const [],
      this.isConnected = false,
      this.isLoadingChat = true,
      this.isWritingBot = false,});

  ChatState copyWith({
    List<Message>? messageList,
    bool? isConnected,
    bool? isLoadingChat,
    bool? isWritingBot,
  }) =>
      ChatState(
        messageList: messageList ?? this.messageList,
        isConnected: isConnected ?? this.isConnected,
        isLoadingChat: isLoadingChat ?? this.isLoadingChat,
        isWritingBot: isWritingBot ?? this.isWritingBot,
      );
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ScrollController chatScrollController = ScrollController();
  late GenerativeModel chatModel;
  final List<Content> history = [];

  final DataHistoryService dataHistoryService = DataHistoryService();

  ChatNotifier() : super(ChatState()) {
    configureChatModel();
    _startListeningToConnectivity();
    loadConversation();
  }

  void configureChatModel() {
    chatModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: "AIzaSyDHjbUqF2thTON9DUgwa_6ocvBQgq4aL2A",
    );
  }

  void _startListeningToConnectivity() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      updateConnectionStatus(connectivityResult);
    });
  }

  void updateConnectionStatus(ConnectivityResult result) {
    bool connected = result != ConnectivityResult.none;
    state = state.copyWith(isConnected: connected);
  }

  Future<void> geminiMessage(text) async {
    final newMessageGemini = Message(text: text, fromWho: FromWho.gemini);
    state = state.copyWith(
        messageList: [...state.messageList, newMessageGemini]);
    moveScrollToBottom();
    await dataHistoryService.saveConversation(state.messageList);
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final newMessage = Message(text: text, fromWho: FromWho.me);
    state = state.copyWith(
      messageList: [...state.messageList, newMessage],
    );
    history.add(Content.text(text));
    moveScrollToBottom();
    geminiResponse(text);
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Future<void> loadConversation() async {
    final listMessages = await dataHistoryService.loadConversation();
    if (listMessages != null) {
      List<Message> restoredMessages = listMessages.map((msgStr) {
        var msg = jsonDecode(msgStr);
        return Message(
          text: msg['text'],
          fromWho: msg['fromWho'] == 'me' ? FromWho.me : FromWho.gemini,
        );
      }).toList();
      state = state.copyWith(messageList: restoredMessages);
    }
    for (var message in state.messageList) {
      if (message.fromWho == FromWho.me) {
        history.add(Content.text(message.text));
      } else {
        history.add(Content.model([TextPart(message.text)]));
      }
    }

    state = state.copyWith(isLoadingChat: false);
    moveScrollToBottom();
  }

  Future<void> geminiResponse(String text) async {
    state = state.copyWith(isWritingBot: true);
    final chat = chatModel.startChat(history: history);
    var response = await chat.sendMessage(Content.text(text));
    history.add(Content.model([TextPart(response.text!)]));
    await geminiMessage(response.text);
    state = state.copyWith(isWritingBot: false);
  }


   Future<void> newConversation() async {
    state = state.copyWith(messageList: [], isLoadingChat: true);
    history.clear();
    await dataHistoryService.clearConversation();
    state = state.copyWith(isLoadingChat: false);
  }


}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
