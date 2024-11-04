import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoService {
  Future<List<Todo>> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoData = prefs.getStringList('todos');
    return todoData != null
        ? todoData.map((item) => Todo.fromJson(json.decode(item))).toList()
        : [];
  }

  Future<void> saveTodos(List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoData =
        todos.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('todos', todoData);
  }
}
