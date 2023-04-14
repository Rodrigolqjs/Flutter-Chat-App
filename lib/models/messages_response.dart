// To parse this JSON data, do
//
//     final messagesResponse = messagesResponseFromMap(jsonString);

import 'dart:convert';

class MessagesResponse {
  MessagesResponse({
    required this.ok,
    required this.messages,
  });

  bool ok;
  List<Message> messages;

  factory MessagesResponse.fromJson(String str) =>
      MessagesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessagesResponse.fromMap(Map<String, dynamic> json) =>
      MessagesResponse(
        ok: json["ok"],
        messages:
            List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toMap())),
      };
}

class Message {
  Message({
    required this.message,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
  });

  String message;
  String from;
  String to;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        message: json["message"],
        from: json["from"],
        to: json["to"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "from": from,
        "to": to,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
