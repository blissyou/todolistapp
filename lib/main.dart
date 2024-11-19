import 'package:flutter/material.dart';
import 'package:todolist/controller/todo_provider.dart';
import 'screens/todo_navigationbar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Navigationbar(),
    );
  }
}
