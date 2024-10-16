import 'package:provider/provider.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:flutter/material.dart';

class MessageField extends StatelessWidget {
  final bool isConnected;
  const MessageField({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final textController = TextEditingController();
    final focusNode = FocusNode();
    final outlineInputBorder = UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));
    final chatProvider = context.read<ChatProvider>();

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      focusNode: focusNode,
      controller: textController,
      onFieldSubmitted: (value) {
        textController.clear();
        focusNode.requestFocus();
        chatProvider.sendMessage(value);
      },
      decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          filled: true,
          suffixIcon: IconButton(

              color: colors.primary,
              onPressed: isConnected
                  ? () {
                      final textValue = textController.value.text;
                      textController.clear();
                      chatProvider.sendMessage(textValue);
                    }
                  : null,
              icon: const Icon(Icons.send))),
    );
  }
}
