import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String texto1;
  final String texto2;

  const Labels(
      {Key? key,
      required this.ruta,
      required this.texto1,
      required this.texto2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(texto1,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w300,
                fontSize: 15)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, this.ruta);
          },
          child: Text(texto2,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
      ]),
    );
  }
}
