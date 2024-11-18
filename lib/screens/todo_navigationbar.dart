import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'calendar.dart';
import 'todo_add_screen.dart';
import 'todo_help_screen.dart';
import '../services/todo_service.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});
  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int _pageIndex = 1;
  final List<Widget> _pages = [Calendar(), TodoListScreen(), test()];
  final TodoService _todoService = TodoService();
  List<Todo> todos = [];
  Future<void> _loadTodos() async {
    todos = await _todoService.loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _pageIndex,
          children: _pages,
        ),
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.white,
            color: Color.fromARGB(255, 135, 201, 255),
            buttonBackgroundColor: Color.fromARGB(255, 168, 213, 250),
            index: 1,
            items: <Widget>[
              Icon(Icons.calendar_month_rounded, size: 20),
              Icon(Icons.add, size: 30),
              Icon(Icons.people, size: 20)
            ],
            height: 50,
            animationDuration: Duration(milliseconds: 400),
            onTap: (index) async {
              _loadTodos();
              print(todos);
              setState(() {
                _pageIndex = index;
              });
            }));
  }
}
