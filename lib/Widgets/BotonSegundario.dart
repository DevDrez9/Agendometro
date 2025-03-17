import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text; // Texto del botón
  final VoidCallback onPressed; // Acción al presionar el botón

  const SecondaryButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppTheme.mainSize,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              foregroundColor: AppThemeColors.secondary, // Color del texto
              side: const BorderSide(
                  color: AppThemeColors.textPrimary), // Borde del botón
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
