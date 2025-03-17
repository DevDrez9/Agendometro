import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final Function(String) onDateSelected;

  const DatePickerField(
      {super.key, required this.label, required this.onDateSelected});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restringe fechas pasadas
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
      widget.onDateSelected(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppTheme.medioSize,
        height: 60,
        child: TextFormField(
          controller: _dateController,
          readOnly: true, // Evita que el usuario escriba manualmente
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle:
                const TextStyle(color: Colors.black54), // Color del label
            suffixIcon: const Icon(Icons.calendar_today,
                color: Colors.black54), // Icono de calendario
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black54), // Línea inferior
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black), // Línea inferior activa
            ),
          ),
        ));
  }
}
