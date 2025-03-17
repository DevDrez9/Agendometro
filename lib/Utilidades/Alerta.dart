import 'package:flutter/material.dart';

Future<void> Alerta(BuildContext context, String titulo, String mensaje) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    ),
  );
}
