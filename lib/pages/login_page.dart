import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(titulo: 'Messenger'),
                  _Form(),
                  Labels(
                      ruta: 'register',
                      texto1: '¿No tienes Cuenta?',
                      texto2: 'Crea una ahora!'),
                  Text('Términos y condiciones de uso',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                      )),
                ]),
          ),
        )));
  }
}

class _Form extends StatefulWidget {
  _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          icon: Icons.mail_outline,
          placeholder: 'Correo',
          keyboarType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),
        CustomInput(
          icon: Icons.lock_outline,
          placeholder: 'Contraseña',
          keyboarType: TextInputType.visiblePassword,
          isPassword: true,
          textController: passCtrl,
        ),
        BotonAzul(
          texto: 'Ingrese!',
          onPress: authService.autenticando
              ? null
              : () async {
                  FocusScope.of(context).unfocus();

                  final loginOk = await authService.login(
                      emailCtrl.text.trim(), passCtrl.text.trim());

                  if (loginOk) {
                    // TODO Conectar a nuestro server

                    // Navegar sin poder devolverme a otra pantalla
                    Navigator.pushReplacementNamed(context, 'usuarios');
                  } else {
                    // Mostrar alerta
                    mostrarAlerta(context, 'Login Incorrecto',
                        'Revise sus credenciales nuevamente');
                  }
                },
        )
      ]),
    );
  }
}
