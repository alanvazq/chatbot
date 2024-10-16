import 'dart:convert';
import 'package:chatbot/entities/message.dart';
import 'package:chatbot/services/data_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final gemini = Gemini.instance;
  final DataHistoryService dataHistoryService = DataHistoryService();

  List<Message> messageList = [];
  bool isLoading = true;

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);
    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> geminiMessage(text) async {
    final newMessageGemini = Message(text: text, fromWho: FromWho.gemini);
    messageList.add(newMessageGemini);
    notifyListeners();
    moveScrollToBottom();
    await dataHistoryService.saveConversation(messageList);
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Future<void> geminiResponse(String text) async {
    final tempMessage =
        Message(text: "Escribiendo...", fromWho: FromWho.gemini);
    messageList.add(tempMessage);
    notifyListeners();

    String accumulatedText = '';

    gemini.streamGenerateContent(text).listen((value) {
      if (value.output != null) {
        accumulatedText += value.output!;
      }
    }, onDone: () {
      messageList.remove(tempMessage);

      if (accumulatedText.isNotEmpty) {
        geminiMessage(accumulatedText);
      }
    }, onError: (e) {
      messageList.remove(tempMessage);
      notifyListeners();
      print('Error $e');
    });
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

      messageList = restoredMessages;
    }
    isLoading = false;
    notifyListeners();
  }
}
