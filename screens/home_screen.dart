import 'package:flutter/material.dart';
import '../database/db-helper.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

TextEditingController searchController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  DBHelper dbHelper = DBHelper();
  List<Task> tasks = [];
  String filter = "all";

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await dbHelper.getTasks(filter: filter);

    if (searchController.text.isNotEmpty) {
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ) ||
            task.description.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );
      }).toList();
    }

    setState(() {});
  }

  void toggleStatus(Task task) async {
    task.status = task.status == "pending" ? "completed" : "pending";
    await dbHelper.updateTask(task);
    loadTasks();
  }

  void deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TaskTrack")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                loadTasks();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  filter = "all";
                  loadTasks();
                },
                child: Text("All"),
              ),
              TextButton(
                onPressed: () {
                  filter = "pending";
                  loadTasks();
                },
                child: Text("Pending"),
              ),
              TextButton(
                onPressed: () {
                  filter = "completed";
                  loadTasks();
                },
                child: Text("Completed"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return Dismissible(
                  key: Key(task.id.toString()),
                  onDismissed: (direction) {
                    deleteTask(task.id!);
                  },
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.status == "completed"
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text("Due: ${task.dueDate} | ${task.priority}"),
                    leading: Checkbox(
                      value: task.status == "completed",
                      onChanged: (value) {
                        toggleStatus(task);
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(task: task),
                        ),
                      );
                      loadTasks();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          loadTasks();
        },
      ),
    );
  }
}
