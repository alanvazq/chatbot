import 'package:chatbot/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MessageField extends ConsumerStatefulWidget {
  const MessageField({super.key});

  @override
  ConsumerState<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends ConsumerState<MessageField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _textController.text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final chatState = ref.watch(chatProvider);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              focusNode: _focusNode,
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
                        .sendMessage(_textController.text);
                    _textController.clear();
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
            onPressed: _isListening ? _stopListening : _startListening,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: colors.secondary,
            ),
            child: Icon(
              _isListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
