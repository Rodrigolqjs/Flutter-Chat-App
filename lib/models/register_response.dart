// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromMap(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user.dart';

class RegisterResponse {
  RegisterResponse({
    required this.ok,
    required this.user,
    required this.token,
  });

  bool ok;
  User user;
  String token;

  factory RegisterResponse.fromJson(String str) =>
      RegisterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromMap(Map<String, dynamic> json) =>
      RegisterResponse(
        ok: json["ok"],
        user: User.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "user": user.toMap(),
        "token": token,
      };
}
