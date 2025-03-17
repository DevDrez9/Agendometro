import 'package:flutter/material.dart';

Future<bool> AlertaOp(
    BuildContext context, String titulo, String mensaje) async {
  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false); // Retorna false
          },
          child: Text("No"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true); // Retorna true
          },
          child: Text("Si"),
        ),
      ],
    ),
  );
  return result;
}
