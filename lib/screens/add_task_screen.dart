import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db.helper.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String priority = "low";
  String status = "pending";
  String dueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DBHelper dbHelper = DBHelper();

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dueDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void saveTask() async {
    if (titleController.text.isEmpty) return;

    Task task = Task(
      title: titleController.text,
      description: descController.text,
      dueDate: dueDate,
      status: status,
      priority: priority,
    );

    await dbHelper.insertTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text("Due Date: $dueDate"),
                ),
                TextButton(
                  onPressed: pickDate,
                  child: Text("Select Date"),
                )
              ],
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: priority,
              isExpanded: true,
              items: ["low", "medium", "high"]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                priority = value!;
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTask,
              child: Text("Save Task"),
            )
          ],
        ),
      ),
    );
  }
}