import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importar soporte de idiomas

class DateSelector extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DateSelector({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('es');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.mainSize,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          TableCalendar(
            locale: 'es',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDateSelected(selectedDay);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: AppThemeColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppThemeColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ],
      ),
    );
  }
}
