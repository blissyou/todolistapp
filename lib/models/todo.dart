import 'package:intl/intl.dart';

class Todo {
  final String title;
  final String createdAt;
  bool isChecked;

  Todo({required this.title, this.isChecked = false, String? createdAt})
    : createdAt =
            createdAt ?? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  Map<String, dynamic> toJson() {
    return {'title': title, 'createdAt': createdAt, 'isChecked': isChecked};
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isChecked: json['isChecked'],
      createdAt: json['createdAt'],
    );
  }
}
