import 'dart:convert';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  //
  late Usuario usuario;
  bool _autenticando = false;

  // flutter secure Storage
  final _storage = const FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //  Getters del token de forma estatica
  static Future<String> getToken() async {
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'token') ?? '';
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = const FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  // Esta funcion es la encargada de enviar la peticion http al server
  Future login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  // Guardando token
  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  // Eliminando token
  Future logoutToken() async {
    return await _storage.delete(key: 'token');
  }

  // Marzo 16 : 11am Añadiendo register
  Future register(String nombre, String email, String password) async {
    this.autenticando = true;
    // print('Este es el nombre desde el registro $nombre');
    // print('Este es el nombre desde el registro $email');
    // print('Este es el nombre desde el registro $password');
    final data = {'nombre': nombre, 'email': email, 'password': password};
    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      // Sirve para mapear un json string a un mapa
      final respBoby = jsonDecode(resp.body);
      print(respBoby['msg']);
      return respBoby['msg'];
    }
  }

  // Vamos a comprobar el token de acceso
  Future isLoggedIn() async {
    // Con esto leemos el token
    final token = await this._storage.read(key: 'token') ?? '';

    // verificamos el token.. Enviandole el token para ver si
    // es valido o no
    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});

    print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      this.logoutToken();
      return false;
    }

    print(token);
  }
}
