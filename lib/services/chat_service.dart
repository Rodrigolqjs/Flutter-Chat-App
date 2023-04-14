import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class ChatService with ChangeNotifier {
  User? recipient;

  Future getChat(String recipientId) async {
    final resp = await http.get(
      Uri.parse('${Environment.apiUrl}/messages/$recipientId'),
      headers: {
        'Content-Type': 'Application/json',
        'x-token': await AuthService.getToken(),
      },
    );

    final messagesResponse = MessagesResponse.fromJson(resp.body);

    return messagesResponse.messages;
  }
}
