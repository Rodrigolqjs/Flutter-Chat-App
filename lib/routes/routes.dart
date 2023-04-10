import 'package:chat_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => const UsersScreen(),
  'login': (_) => const LoginScreen(),
  'register': (_) => const RegisterScreen(),
  'chat': (_) => const ChatScreen(),
  'loading': (_) => const LoadingScreen(),
};
