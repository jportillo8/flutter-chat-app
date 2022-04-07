import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _focusNode = new FocusNode();
  final _textController = new TextEditingController();

  // Para mandar mensajes entonces..
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket!.on('mensaje-personal', _escucharMensaje);

    // Colocando lista de mensajes
    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    // print(chat);
    final history = chat.map((m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    // print('Tengo mensaje $payload ');
    final mensaje = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 800),
      ),
    );

    setState(() {
      _messages.insert(0, mensaje);
    });

    mensaje.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(children: [
          CircleAvatar(
            maxRadius: 14,
            backgroundColor: Colors.blue[100],
            child: Text(usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          SizedBox(height: 3),
          Text(usuarioPara.nombre,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ]),
      ),
      body: Container(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _messages[i])),
          Divider(height: 12),
          // TODO Caja de texto
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ]),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: [
        Flexible(
            child: TextField(
          focusNode: _focusNode,
          controller: _textController,
          onSubmitted: _handleSubmit,
          onChanged: (String texto) {
            setState(() {
              if (texto.trim().length > 0) {
                _estaEscribiendo = true;
              } else {
                _estaEscribiendo = false;
              }
            });
            // TODO cuando hay un valor para poder postear
          },
          decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
        )),

        // Boton de enviar
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null)
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: Icon(Icons.send)),
                    ),
                  ))
      ]),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    // print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
        texto: texto,
        uid: authService.usuario.uid,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 400)));
    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });

    @override
    void dispose() {
      // TODO off del socket
      for (ChatMessage message in _messages) {
        message.animationController.dispose();
      }

      super.dispose();
    }
  }
}
