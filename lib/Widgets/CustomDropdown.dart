import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items; // Lista de opciones
  final String label;
  final TextEditingController controller; // Controlador del valor seleccionado
  final FormFieldValidator<String>? validator; // Validador opcional

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue; // Guarda el valor seleccionado

  @override
  void initState() {
    super.initState();
    selectedValue =
        widget.controller.text.isNotEmpty ? widget.controller.text : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.mainSize,
      child: DropdownButtonFormField<String>(
        value:
            selectedValue, // Usa la variable interna en lugar del controlador
        decoration: InputDecoration(
          labelText: widget.label, // Label persistente
          labelStyle: TextStyle(color: Colors.black54), // Color del label
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black54), // Línea inferior cuando está habilitado
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppThemeColors
                    .primary), // Línea inferior cuando está enfocado
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red), // Línea inferior cuando hay un error
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .red), // Línea inferior cuando hay un error y está enfocado
          ),
        ),
        isExpanded: true,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue; // Actualiza la UI
            widget.controller.text = newValue ?? ''; // Actualiza el controlador
          });
        },
        validator: widget.validator, // Validador opcional
      ),
    );
  }
}
