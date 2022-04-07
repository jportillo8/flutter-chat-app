import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Se usa un FutureBuilder por que vamos a esperar
        // a q una tarea se realiza
        body: FutureBuilder(
      // Este el future que estamos esperando
      future: checkLoginState(context),
      builder: (context, snapshot) {
        return Center(
          child: Text('Espere....'),
        );
      },
    ));
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context, listen: false);
    // Que a su vez dependiendo de esta respuesta nos manda
    // al login o al chat
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsuariosPage(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
