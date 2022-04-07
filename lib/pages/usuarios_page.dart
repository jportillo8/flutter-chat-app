import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosService = new UsuariosService();

  // Pull refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario(
  //       online: true,
  //       email: 'correo0@gmail.com',
  //       nombre: 'Lucreciax',
  //       uid: '1'),
  //   Usuario(
  //       online: false,
  //       email: 'correo1@gmail.com',
  //       nombre: 'LucreciaY',
  //       uid: '2'),
  //   Usuario(
  //       online: true,
  //       email: 'correo2@gmail.com',
  //       nombre: 'LucreciaZ',
  //       uid: '3'),
  // ];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.usuario;

    return Scaffold(
        appBar: AppBar(
          title: Text(user.nombre, style: TextStyle(color: Colors.black54)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                socketService.disconnect();
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              },
              icon: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.black54,
              )),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                // child: Icon(Icons.check_circle, color: Colors.red),
                child: socketService.serverStatus == ServerStatus.Online
                    ? Icon(Icons.offline_bolt, color: Colors.green)
                    : Icon(Icons.check_circle, color: Colors.red))
          ],
        ),
        body: SmartRefresher(
          // Pull Refresh
          onRefresh: _cargarUsuarios,
          controller: _refreshController,
          enablePullDown: true,
          child: _listViewUsuarios(),
          // header: WaterDropHeader(
          //   complete: Icon(Icons.verified_user, color: Colors.blue[400]),
          //   waterDropColor: Colors.blue,
          // ),
          header: WaterDropMaterialHeader(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTitle(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTitle(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

// Pull Refresh
  _cargarUsuarios() async {
    this.usuarios = await usuariosService.getUsuarios();

    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
