import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/todo_provider.dart';

class TodoListScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _confirmDelete(BuildContext context, int index) {
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
                Provider.of<TodoProvider>(context, listen: false)
                    .removeTodoAt(index);
                Navigator.of(context).pop();
              },
              child: Text("확인", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addNewTodo(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      Provider.of<TodoProvider>(context, listen: false)
          .addTodo(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 135, 201, 255),
        title: Text('To Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('할 일 추가'),
                    content: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '할 일을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) {
                        _addNewTodo(context);
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          _addNewTodo(context);
                          Navigator.of(context).pop();
                        },
                        child: Text('추가'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoProvider.todos.length,
        itemBuilder: (_, index) {
          final todo = todoProvider.todos[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              _confirmDelete(context, index);
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
                  todoProvider.toggleTodoStatus(index);
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
    );
  }
}
