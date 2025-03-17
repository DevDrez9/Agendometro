import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField2 extends StatefulWidget {
  final String label;
  final TextEditingController controller; // Controlador para el campo de fecha
  final FormFieldValidator<String>? validator; // Validador opcional

  const DatePickerField2({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  _DatePickerField2State createState() => _DatePickerField2State();
}

class _DatePickerField2State extends State<DatePickerField2> {
  @override
  void initState() {
    super.initState();
    // Si el controlador ya tiene un valor, se establece en el campo de fecha
    if (widget.controller.text.isNotEmpty) {
      _dateController.text = widget.controller.text;
    }
  }

  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Restringe fechas pasadas
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
        widget.controller.text =
            formattedDate; // Actualiza el controlador del padre
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de selección de fecha
        Container(
          width: 315,
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
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.red), // Línea inferior cuando hay un error
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors
                        .red), // Línea inferior cuando hay un error y está enfocado
              ),
            ),
            validator: widget.validator, // Validador personalizado
          ),
        ),
      ],
    );
  }
}
