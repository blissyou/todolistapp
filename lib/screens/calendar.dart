import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 10),
      lastDay: DateTime.utc(2050, 10, 10),
      focusedDay: DateTime.now(),
    );
  }
}


//TODO: 캘린더에서 클릭하면 그날에 채크리스트 히스트로가 뜸 그리고 캘린더에 표시가 되게 하기