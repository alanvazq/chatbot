import 'package:chatbot/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataHistoryService {
  Future<void> saveConversation(List<Message> messages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> messagesList = messages
        .map((msg) => jsonEncode({
              "text": msg.text,
              "fromWho": msg.fromWho == FromWho.me ? 'me' : 'gemini',
            }))
        .toList();

    prefs.setStringList('conversation', messagesList);
  }

  Future<List<String>?> loadConversation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesList = prefs.getStringList('conversation');
    return messagesList;
  }

  Future<void> clearConversation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('conversation'); 
  }
}
