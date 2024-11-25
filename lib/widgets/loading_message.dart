import 'package:flutter/material.dart';

class LoadingMessage extends StatelessWidget {
  const LoadingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            )),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
