import 'dart:io';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();
  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  // ignore: prefer_final_fields
  List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService?.socket.on('personal-message', _messageListener);
    _loadMessages(chatService!.recipient!.uid);
  }

  void _loadMessages(String recipientId) async {
    List<Message> chat = await chatService!.getChat(recipientId);
    final history = chat.map(
      (e) => ChatMessage(
        text: e.message,
        uid: e.from,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 0),
        )..forward(),
      ),
    );

    _messages.insertAll(0, history);
    setState(() {});
  }

  void _messageListener(dynamic payload) {
    ChatMessage message = ChatMessage(
      text: payload['message'],
      uid: payload['from'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _messages.insert(0, message);
    setState(() {});
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final recipient = chatService?.recipient;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.lightBlueAccent,
                maxRadius: 14,
                child: Text(recipient!.name.substring(0, 2),
                    style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 3),
              Text(
                recipient.name,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
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
                  if (value.isNotEmpty) {
                    _isTyping = true;
                  } else {
                    _isTyping = false;
                  }
                  setState(() {});
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
    if (text.isNotEmpty) {
      final newMessage = ChatMessage(
        text: text,
        uid: authService!.user!.uid,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      );
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
    }

    _isTyping = false;
    setState(() {});
    socketService?.socket.emit('personal-message', {
      'from': authService!.user!.uid,
      'to': chatService!.recipient!.uid,
      'message': text,
    });
  }

  @override
  void dispose() {
    _messages.forEach((element) => element.animationController.dispose());

    socketService?.socket.off('personal-message');
    super.dispose();
  }
}
