
import 'package:flutter/material.dart';
import '../database/db.helper.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late String priority;
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.task.title);
    descController =
        TextEditingController(text: widget.task.description);
    priority = widget.task.priority;
  }

  void updateTask() async {
    widget.task.title = titleController.text;
    widget.task.description = descController.text;
    widget.task.priority = priority;

    await dbHelper.updateTask(widget.task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController),
            TextField(controller: descController),
            DropdownButton<String>(
              value: priority,
              items: ["low", "medium", "high"]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                priority = value!;
                setState(() {});
              },
            ),
            ElevatedButton(
              onPressed: updateTask,
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}