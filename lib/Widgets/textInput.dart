import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

Widget textInput({
  required TextEditingController controller,
  required String labelText,
  bool isEmail = false,
  bool isPassword = false,
  bool isNumberOnly = false,
  bool isTextOnly = false,
  bool isValidatorEnabled =
      true, // Nuevo parámetro para habilitar/deshabilitar la validación
  IconData? icon, // Ícono opcional
  Function(String)? onChanged, // onChanged opcional
}) {
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Puedes personalizar la validación de la contraseña según tus necesidades
    return password.length >= 6;
  }

  bool isNumber(String value) {
    final RegExp numberRegex = RegExp(r'^\d*\.?\d*$');
    return numberRegex.hasMatch(value);
  }

  // Estado para controlar si la contraseña es visible o no
  bool isPasswordVisible = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        width: AppTheme.mainSize,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
                TextStyle(color: AppThemeColors.textPrimary), // Color del label
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppThemeColors.textPrimary), // Color del borde en foco
            ),
            suffixIcon: isPassword
                ? Row(
                    mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Row
                    children: [
                      if (icon !=
                          null) // Muestra el ícono personalizado si existe
                        Icon(icon),
                      IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ],
                  )
                : icon != null
                    ? Icon(icon) // Muestra solo el ícono personalizado
                    : null,
          ),
          controller: controller,
          obscureText: isPassword &&
              !isPasswordVisible, // Oculta el texto si es una contraseña y no está visible
          keyboardType:
              isNumberOnly ? TextInputType.number : TextInputType.text,
          onChanged: onChanged, // onChanged opcional
          validator: isValidatorEnabled
              ? (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa $labelText';
                  } else if (isEmail && !isValidEmail(value)) {
                    return 'Ingrese un correo válido';
                  } else if (isPassword && !isValidPassword(value)) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  } else if (isNumberOnly && !isNumber(value)) {
                    return 'Ingrese solo números';
                  }
                  return null; // No hay validación para "solo texto"
                }
              : null, // Si el validador no está habilitado, retorna null
        ),
      );
    },
  );
}
