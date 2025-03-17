import 'package:agendometro/Pages/HomePage.dart';
import 'package:agendometro/Pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> AtrasOpp(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('¿Estás seguro?'),
          content: Text('¿Quieres salir de la aplicación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
              child: Text('Sí'),
            ),
          ],
        ),
      ) ??
      false;
}

Future<bool> NoAtras(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
  return false;
}

Future<bool> SalirApp(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('¿Estás seguro?'),
          content: Text('¿Quieres salir de la aplicación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text('Sí'),
            ),
          ],
        ),
      ) ??
      false;
}
