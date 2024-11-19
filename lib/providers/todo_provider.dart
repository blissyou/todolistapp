import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider with ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  Map<String, List<Todo>> _todosByDate = {};
  bool _isLoading = false;
  List<Todo> get todos => _todos;
  Map<String, List<Todo>> get todosByDate => _todosByDate;

  Future<void> loadTodos() async {
    if (_isLoading) return; //중복 로드 방지
    _isLoading = true;

    _todos.clear();
    _todosByDate.clear();
    _todos = await _todoService.loadTodos();
    _groupTodosByDate();
    notifyListeners();
  }

  Future<void> _saveTidisSafely() async {
    final uniqueTods = _todos.toSet().toList();
    await _todoService.saveTodos(uniqueTods);
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(title: title);
    _todos.add(newTodo);
    _groupTodosByDate();
    await _todoService.saveTodos(_todos);
    notifyListeners();
  }

  Future<void> removeTodoAt(int index) async {
    _todos.removeAt(index);
    _groupTodosByDate();
    await _todoService.saveTodos(_todos);
    notifyListeners();
  }

  Future<void> toggleTodoStatus(int index) async {
    _todos[index].isChecked = !_todos[index].isChecked;
    await _todoService.saveTodos(_todos);
    notifyListeners();
  }

  void _groupTodosByDate() {
    _todosByDate.clear();
    for (var todo in _todos) {
      final date = _formatDate(todo.createdAt);
      if (!_todosByDate.containsKey(date)) {
        _todosByDate[date] = [];
      }
      _todosByDate[date]!.add(todo);
    }
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }
}
