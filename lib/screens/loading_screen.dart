import 'package:chat_app/screens/screens.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    //* Para borrar token
    // AuthService.logout('token');
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      socketService.connect();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UsersScreen(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    }
  }
}
