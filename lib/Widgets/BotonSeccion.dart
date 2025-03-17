import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class BotonSeccion extends StatelessWidget {
  final String text; // Texto del botón
  final VoidCallback onPressed; // Acción al presionar el botón
  final Color color;

  const BotonSeccion({
    required this.text,
    required this.onPressed,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 30,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: color, // Color de fondo
              foregroundColor: Colors.white, // Color del texto
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              )),
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ));
  }
}
