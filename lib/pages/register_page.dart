import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
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
                  Logo(titulo: 'Registro'),
                  _Form(),
                  Labels(
                      ruta: 'login',
                      texto1: '¿Ya tienes Cuenta?',
                      texto2: 'Ingresa con ella Ahora!'),
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
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          icon: Icons.perm_identity,
          placeholder: 'Nombre',
          keyboarType: TextInputType.text,
          textController: nombreCtrl,
        ),
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
            onPress: () {
              print(emailCtrl.text);
              print(passCtrl.text);
            })
      ]),
    );
  }
}
