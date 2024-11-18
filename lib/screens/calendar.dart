import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // 캘린더가 빌드될 때 데이터를 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todosByDate = todoProvider.todosByDate;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            firstDay: DateTime.utc(2010, 10, 10),
            lastDay: DateTime.utc(2050, 10, 10),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            locale: 'ko_KR',
            headerVisible: true,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              final formattedDate = _formatDate(day);
              return todosByDate[formattedDate] ?? [];
            },
          ),
          const SizedBox(height: 16),
          if (_selectedDay != null)
            Expanded(
              child: todosByDate[_formatDate(_selectedDay!)] != null
                  ? ListView.builder(
                      itemCount:
                          todosByDate[_formatDate(_selectedDay!)]!.length,
                      itemBuilder: (context, index) {
                        final todo =
                            todosByDate[_formatDate(_selectedDay!)]![index];
                        return CheckboxListTile(
                          title: Text(todo.title),
                          value: todo.isChecked,
                          onChanged: null, // 캘린더에서는 체크 불가
                          controlAffinity: ListTileControlAffinity.leading,
                          tileColor: todo.isChecked
                              ? Colors.grey[200]
                              : null, // 체크된 항목 표시
                        );
                      },
                    )
                  : Center(child: Text('선택한 날짜에 일정이 없습니다.')),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
