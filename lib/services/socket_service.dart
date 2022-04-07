import 'dart:developer';

import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// Manejo del estatusIcon(Icons.check_circle, color: Colors.red)
enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket? get socket => this._socket;
  Function get emit => _socket!.emit;

// Autenticando el usuario que corresponde
  void connect() async {
    final token = await AuthService.getToken();

    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnet': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket!.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      log(_serverStatus.toString());
      notifyListeners();
    });
    _socket!.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket!.disconnect();
    print(_socket);
  }
}
