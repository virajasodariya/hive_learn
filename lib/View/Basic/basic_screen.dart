import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BasicScreen extends StatefulWidget {
  const BasicScreen({super.key});

  @override
  State<BasicScreen> createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();

  late Box<String> contacts;

  @override
  void initState() {
    contacts = Hive.box<String>("contacts");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Contacts"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: contacts.listenable(),
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final key = contacts.keys.toList()[index];
                    final value = contacts.get(key);

                    return ListTile(
                      title: Text("$key"),
                      subtitle: Text("$value"),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  buildShowDialog(context);
                },
                child: const Text("Add New"),
              ),
              ElevatedButton(
                onPressed: () {
                  buildShowDialog(context);
                },
                child: const Text("update"),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: id,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: ' Enter your id'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  String key = id.text;

                                  await contacts.delete(key);

                                  Get.back();

                                  id.clear();
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
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
                  controller: id,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: ' Enter your id'),
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(hintText: ' Enter your Name'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String key = id.text;
                    String value = name.text;

                    await contacts.put(key, value);

                    Get.back();

                    id.clear();
                    name.clear();
                  },
                  child: const Text('SUBMIT'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
