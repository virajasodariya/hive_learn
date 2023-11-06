import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_learn/main.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController hobbyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late Box userBox;

  @override
  void initState() {
    userBox = Hive.box(userBoxName);
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

  AppBar appBar() {
    return AppBar(
      title: const Text("Flutter Hive Database"),
      centerTitle: true,
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        createData(context);
      },
      child: const Icon(Icons.add),
    );
  }

  ValueListenableBuilder<Box<dynamic>> buildBody() {
    return ValueListenableBuilder(
      valueListenable: userBox.listenable(),
      builder: (context, box, child) {
        final keys = box.keys.cast<int>().toList();

        return ListView.builder(
          itemCount: keys.length,
          itemBuilder: (context, index) {
            final key = keys[index];
            final user = box.get(key);

            return ListTile(
              onTap: () {
                deleteData(context, key);
              },
              leading: InkResponse(
                onTap: () {
                  updateData(context, key);
                },
                child: const Icon(Icons.edit_outlined),
              ),
              title: Text(user["name"] ?? ''),
              subtitle: Text(user["description"] ?? ''),
              trailing: Text(user["hobby"] ?? ''),
            );
          },
        );
      },
    );
  }

  Future<dynamic> createData(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextField(
                  controller: hobbyController,
                  decoration: const InputDecoration(hintText: "Hobbies"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text;
                    String hobby = hobbyController.text;
                    String description = descriptionController.text;

                    var value = {
                      "name": name,
                      "hobby": hobby,
                      "description": description,
                    };

                    await userBox.add(value);

                    Get.back();

                    nameController.clear();
                    hobbyController.clear();
                    descriptionController.clear();
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> updateData(BuildContext context, int key) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextField(
                  controller: hobbyController,
                  decoration: const InputDecoration(hintText: "Hobbies"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text;
                    String hobby = hobbyController.text;
                    String description = descriptionController.text;

                    var value = {
                      "name": name,
                      "hobby": hobby,
                      "description": description,
                    };

                    await userBox.put(key, value);

                    Get.back();

                    nameController.clear();
                    hobbyController.clear();
                    descriptionController.clear();
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> deleteData(BuildContext context, int key) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await userBox.delete(key);

                    Get.back();
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
