import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//TODO 캘린더 기능 구현
//TODO 24시가 되면 한 일에 대해서 히스토리로 넘김 
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
    String? createdAt,
  }) : createdAt =
            createdAt ?? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  // JSON 변환을 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdAt': createdAt,
      'isChecked': isChecked,
    };
  }

  // JSON에서 객체로 변환하기 위한 팩토리 생성자
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isChecked: json['isChecked'],
      createdAt: json['createdAt'],
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];
  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadTodos(); // 앱 시작 시 데이터 로드
  }

  // 데이터 로드 함수
  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoData = prefs.getStringList('todos');
    if (todoData != null) {
      setState(() {
        todos =
            todoData.map((item) => Todo.fromJson(json.decode(item))).toList();
      });
    }
  }

  // 데이터 저장 함수
  void _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoData =
        todos.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('todos', todoData);
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
        _isAdding = false; // 입력 후 입력창 닫기
        _saveTodos(); // 할 일 추가 시 데이터 저장
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
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todos.removeAt(index);
                  _saveTodos(); // 삭제 후 데이터 저장
                });
                Navigator.of(context).pop(); // 팝업 닫기
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
                  confirmDismiss: (direction) async {
                    _confirmDelete(index);
                    return false; // 즉시 삭제하지 않도록 함
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
                          _saveTodos(); // 체크박스 변경 시 데이터 저장
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
        ],
      ),
    );
  }
}
