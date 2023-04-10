import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();

  // ignore: prefer_final_fields
  List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.lightBlueAccent,
                maxRadius: 14,
                child: Text('Te', style: TextStyle(fontSize: 12)),
              ),
              SizedBox(height: 3),
              Text(
                'Test 1',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _messages[index],
                  reverse: true,
                ),
              ),
              const Divider(height: 1),
              Container(
                color: Colors.white70,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _isTyping = true;
                    } else {
                      _isTyping = false;
                    }
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: () =>
                          _handleSubmit(_textController.text.trim()))
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue.shade400),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.send),
                          onPressed: _isTyping
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    _textController.clear();
    _focusNode.requestFocus();
    setState(() {
      if (text.isNotEmpty) {
        final newMessage = ChatMessage(
          text: text,
          uid: '123',
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 400),
          ),
        );
        _messages.insert(0, newMessage);
        newMessage.animationController.forward();
      }

      _isTyping = false;
    });
  }

  @override
  void dispose() {
    _messages.forEach((element) => element.animationController.dispose());
    super.dispose();
  }
}
