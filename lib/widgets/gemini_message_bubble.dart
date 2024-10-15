import 'package:flutter/material.dart';

class GeminiMessageBubble extends StatelessWidget {
  const GeminiMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: colors.secondary, borderRadius: BorderRadius.circular(20)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Mensaje",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
