import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoListScreen extends StatefulWidget {
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> todos = [];

  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    todos = await _todoService.loadTodos();
    setState(() {});
  }

  Future<void> _saveTodos() async {
    await _todoService.saveTodos(todos);
  }

  void _toggleAddTodo() {
    setState(() {
      _isAdding = !_isAdding;
    });
  }

  void _addNewTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        todos.add(Todo(title: _controller.text));
        _controller.clear();
        _isAdding = false;
        _saveTodos();
      });
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("삭제 확인"),
          content: Text("정말로 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todos.removeAt(index);
                  _saveTodos();
                });
                Navigator.of(context).pop();
              },
              child: Text("확인", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 135, 201, 255),
        title: Text('To Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _toggleAddTodo,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, index) {
                final todo = todos[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    _confirmDelete(index);
                    return false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          todo.isChecked = value ?? false;
                          _saveTodos();
                        });
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: todo.isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isChecked ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      todo.createdAt,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isAdding)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '할 일을 입력하세요',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addNewTodo(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _addNewTodo,
                  ),
                ],
              ),
            ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
