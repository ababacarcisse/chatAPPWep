import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SingleMessageWidget extends StatelessWidget {
  SingleMessageWidget({super.key, required this.message, required this.isMe});
  final String message;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
                color: isMe ? Colors.green : Color.fromARGB(255, 75, 52, 150),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                )),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ]);
  }
}
