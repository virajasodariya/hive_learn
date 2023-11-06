import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_learn/Model/todo_model.dart';
import 'package:hive_learn/View/Practice/user_list.dart';
import 'package:path_provider/path_provider.dart';

const String todoBoxName = "todo";
const String userBoxName = "user";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);

  await Hive.openBox<String>('contacts');

  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(todoBoxName);

  await Hive.openBox(userBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     primary: Colors.blue,
      //     seedColor: Colors.tealAccent,
      //   ),
      // ),
      home: UserListScreen(),
    );
  }
}
