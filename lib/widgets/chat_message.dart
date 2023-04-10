import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {super.key,
      required this.text,
      required this.uid,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == '123' ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return message(Alignment.centerRight, Colors.blue, 50, 5);
  }

  Widget _notMyMessage() {
    return message(Alignment.centerLeft, Colors.grey, 5, 50);
  }

  Align message(AlignmentGeometry alignment, Color color, double marginLeft,
      double marginRight) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 5,
          left: marginLeft,
          right: marginRight,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
