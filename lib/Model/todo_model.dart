import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String detail;
  @HiveField(2)
  bool isCompleted;

  TodoModel({required this.title, required this.detail, required this.isCompleted});
}
