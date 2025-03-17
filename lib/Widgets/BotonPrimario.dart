import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text; // Texto del botón
  final VoidCallback onPressed; // Acción al presionar el botón

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppTheme.mainSize,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.primary, // Color de fondo
              foregroundColor: Colors.white, // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              )),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ));
  }
}
