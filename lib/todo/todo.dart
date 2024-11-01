import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


//TODO 앱을 꺼다 켜도 할일 목록이 남도록 해야함
//TODO 스와이프 삭제 기능에서 다시 의사를 물어보는 삭제기능을 추가
//TODO 캘린더 기능 추가
//TODO 달 별로 달성한 할일을 그래프로 표현

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: TodoList(),
    );
  }
}

class Todo {
  final String title;
  final String createdAt;
  bool isChecked;

  Todo({
    required this.title,
    this.isChecked = false,
  }) : createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
}

class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];
  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

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
        _isAdding = false; // 입력 후 입력창 닫기
      });
    }
  }

  void _showTopSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _toggleAddTodo,
          ),
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
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      todos.removeAt(index);
                    });
                    _showTopSnackBar("삭제되었습니다");
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          todo.isChecked = value ?? false;
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
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '할 일을 입력하세요',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(),
                        isDense: true, // 입력 필드를 더 compact하게 함
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
        ],
      ),
    );
  }
}
