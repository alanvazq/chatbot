import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/screens/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MessageField extends ConsumerWidget {
  const MessageField({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final chatState = ref.watch(chatProvider);
    final textController = TextEditingController();
    final focusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.primary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15.5)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(113, 48, 48, 48),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.5)),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: chatState.isConnected
                ? () {
                    ref
                        .read(chatProvider.notifier)
                        .sendMessage(textController.text);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: colors.primary,
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
          ElevatedButton(
            onPressed: chatState.isConnected
                ? () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerScreen()));
                  }
                : null,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: colors.primary,
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
