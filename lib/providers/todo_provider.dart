import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider with ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  Map<String, List<Todo>> _todosByDate = {};

  List<Todo> get todos => _todos;
  Map<String, List<Todo>> get todosByDate => _todosByDate;

  Future<void> loadTodos() async {
    _todos = await _todoService.loadTodos();
    _groupTodosByDate();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(title: title);
    _todos.add(newTodo);
    _groupTodosByDate();
    await _todoService.saveTodos(_todos); // 저장
    notifyListeners();
  }

  Future<void> removeTodoAt(int index) async {
    _todos.removeAt(index);
    _groupTodosByDate();
    await _todoService.saveTodos(_todos); // 저장
    notifyListeners();
  }

  Future<void> toggleTodoStatus(int index) async {
    _todos[index].isChecked = !_todos[index].isChecked;
    await _todoService.saveTodos(_todos); // 저장
    notifyListeners();
  }

  void _groupTodosByDate() {
    _todosByDate = {
      for (var todo in _todos)
        _formatDate(todo.createdAt):
            (_todosByDate[_formatDate(todo.createdAt)] ?? [])..add(todo),
    };
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }
}
