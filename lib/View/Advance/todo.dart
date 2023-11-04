import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_learn/Model/todo_model.dart';
import 'package:hive_learn/View/Advance/enum.dart';
import 'package:hive_learn/main.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Box<TodoModel> todoBox;

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  List<String> options = ["All", "Completed", "Incomplete"];

  TodoFilter filter = TodoFilter.ALL;

  @override
  void initState() {
    todoBox = Hive.box(todoBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      floatingActionButton: floatingActionButton(context),
      body: buildBody(),
    );
  }

  /// body
  ValueListenableBuilder<Box<TodoModel>> buildBody() {
    return ValueListenableBuilder(
      valueListenable: todoBox.listenable(),
      builder: (context, value, child) {
        List<int> keys;

        if (filter == TodoFilter.ALL) {
          keys = todoBox.keys.cast<int>().toList();
        } else if (filter == TodoFilter.COMPLETED) {
          keys = todoBox.keys
              .cast<int>()
              .where((element) => value.get(element)!.isCompleted)
              .toList();
        } else {
          keys = todoBox.keys
              .cast<int>()
              .where((element) => !value.get(element)!.isCompleted)
              .toList();
        }

        return ListView.builder(
          itemCount: keys.length,
          itemBuilder: (context, index) {
            final key = keys[index];
            final TodoModel? todo = value.get(key);

            return ListTile(
              onTap: () {
                updateDialog(context, todo, key);
              },
              leading: Text('$key'),
              title: Text(todo!.title),
              subtitle: Text(todo.detail),
              trailing: Icon(
                Icons.check,
                color: todo.isCompleted ? Colors.green : Colors.red,
              ),
            );
          },
        );
      },
    );
  }

  /// update dialog box
  Future<dynamic> updateDialog(BuildContext context, TodoModel todo, int key) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    TodoModel updateModel = TodoModel(
                        title: todo.title, detail: todo.detail, isCompleted: true);

                    todoBox.put(key, updateModel);

                    Get.back();
                  },
                  child: const Text('MARK as READ'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// app bar
  AppBar appBar() {
    return AppBar(
      title: const Text("TODO Hive"),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if (value.compareTo("All") == 0) {
              setState(() {
                filter = TodoFilter.ALL;
              });
            } else if (value.compareTo("Completed") == 0) {
              setState(() {
                filter = TodoFilter.COMPLETED;
              });
            } else {
              setState(() {
                filter = TodoFilter.INCOMPLETE;
              });
            }
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<String>>.generate(
              options.length,
              (int index) {
                return PopupMenuItem<String>(
                  value: options[index],
                  child: Text(options[index]),
                );
              },
            );
          },
        )
      ],
    );
  }

  /// add new entry
  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add New Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      controller: detailController,
                      decoration: const InputDecoration(hintText: 'Details'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final title = titleController.text;
                        final detail = detailController.text;

                        TodoModel todoValue =
                            TodoModel(title: title, detail: detail, isCompleted: false);

                        await todoBox.add(todoValue);

                        Get.back();

                        titleController.clear();
                        detailController.clear();
                      },
                      child: const Text('SUBMIT'),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
