import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

Widget textInput2({
  required TextEditingController controller,
  required String labelText,
  bool isEmail = false,
  bool isPassword = false,
  bool isNumberOnly = false,
  bool isTextOnly = false,
  bool isValidatorEnabled = true,
  IconData? icon,
  Function(String)? onChanged,
  double horizontal = 0,
  int minLines = 1, // Mínimo de renglones
  int? maxLines, // Máximo de renglones (null para que sea infinito)
}) {
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  bool isNumber(String value) {
    final RegExp numberRegex = RegExp(r'^\d*\.?\d*$');
    return numberRegex.hasMatch(value);
  }

  bool isPasswordVisible = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        width: horizontal == 0 ? horizontal : AppTheme.mainSize,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: AppThemeColors.textPrimary),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppThemeColors.textPrimary),
            ),
            suffixIcon: isPassword
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) Icon(icon),
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
                    ? Icon(icon)
                    : null,
          ),
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType:
              isNumberOnly ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          minLines: minLines, // Establece el mínimo de renglones
          maxLines: maxLines ?? minLines, // Establece el máximo de renglones
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
                  return null;
                }
              : null,
        ),
      );
    },
  );
}
