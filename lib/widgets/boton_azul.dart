import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String texto;
  final Function()? onPress;

  const BotonAzul({
    Key? key,
    required this.texto,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: StadiumBorder(), elevation: 2, primary: Colors.blue),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 55,
        child: Text(texto,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      onPressed: this.onPress,
    );
  }
}
