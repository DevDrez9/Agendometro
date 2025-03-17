import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class DropdownHoras extends StatefulWidget {
  final List<String> items; // Lista de opciones
  final Function(String) onChanged; // Callback al padre
  final String label;

  const DropdownHoras({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropdownHorasState createState() => _DropdownHorasState();
}

class _DropdownHorasState extends State<DropdownHoras> {
  String? selectedValue;

  @override
  void didUpdateWidget(covariant DropdownHoras oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Resetear el valor seleccionado si ya no está en la nueva lista de opciones
    if (!widget.items.contains(selectedValue)) {
      setState(() {
        selectedValue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.medioSize,
      height: 60,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppThemeColors.primary),
          ),
        ),
        isExpanded: true,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.split("T")[1]),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onChanged(newValue!);
        },
      ),
    );
  }
}
