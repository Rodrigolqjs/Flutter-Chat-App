import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/register_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? user;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool val) {
    _autenticando = val;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final body = {
      "email": email,
      "password": password,
    };

    final String url = '${Environment.apiUrl}/login';
    //* POST Call
    final resp = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode == 200) {
      final loginRes = LoginResponse.fromJson(resp.body);
      await _saveToken(loginRes.token);
      user = loginRes.user;
      autenticando = false;
      return true;
    } else {
      autenticando = false;
      return false;
    }
  }

  Future<dynamic> register(String email, String password, String name) async {
    final body = {
      "name": name,
      "email": email,
      "password": password,
    };
    final String url = '${Environment.apiUrl}/login/new';
    //* POST Call
    final resp = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final respBody = json.decode(resp.body);
    if (respBody['ok']) {
      final registerRes = RegisterResponse.fromJson(resp.body);
      await _saveToken(registerRes.token);
      user = registerRes.user;
      autenticando = false;
      return true;
    } else {
      return 'Revisar los campos';
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final String url = '${Environment.apiUrl}/login/renew';
    final resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'Application/json',
      'x-token': token ?? '',
    });

    if (resp.statusCode == 200) {
      final loginRes = LoginResponse.fromJson(resp.body);
      user = loginRes.user;
      await _saveToken(loginRes.token);

      return true;
    } else {
      logout('token');
      return false;
    }
  }

  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token ?? '';
  }

  Future _saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future logout(String token) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }
}
