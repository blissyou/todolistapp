import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: todolist(),
    );
  }
}

class Todo {
  final String title;
  final String description;
  Todo({required this.title, required this.description});
}

class todolist extends StatefulWidget {
  @override
  State<todolist> createState() => _todolistState();
}

class _todolistState extends State<todolist> {
  String title = "";
  String decription = "";
  List<Todo> todos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('to do list'), actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      actions: [
                        TextField(
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                            decoration: InputDecoration(hintText: "글 제목")),
                        TextField(
                            onChanged: (value) {
                              setState(() {
                                decription = value;
                              });
                            },
                            decoration: InputDecoration(hintText: "글 내용")),
                        Center(
                            child: TextButton(
                                child: Text("Add"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    todos.add(Todo(
                                        title: title, description: decription));
                                  });
                                }))
                      ],
                    );
                  });
            },
          )
        ]),
        body: ListView.builder(
          itemBuilder: (_, index) {
            return InkWell(
                child: ListTile(
              title: Text(todos[index].title),
              subtitle: Text(todos[index].description),
            ));
          },
          itemCount: todos.length,
        ));
  }
}
