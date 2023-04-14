import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket!;

  void connect() async {
    //* Obtener y pasar token al socket para autentificar
    final token = await AuthService.getToken();
    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      //no estoy seguro de si esta propiedad esta deprecada
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });
    _socket?.on('connect', (_) {
      print('conectado');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket?.on('disconnect', (_) {
      print('desconectado');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket?.on('message', (payload) {
      print('nombre: ${payload['nombre']}');
      print('mensaje: ${payload['mensaje']}');
      print(payload.containsKey('mensaje2')
          ? payload['mensaje2']
          : 'no hay un mensaje 2');
      notifyListeners();
    });

    _socket?.on('active-bands', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
