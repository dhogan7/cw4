import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = []; // List to hold tasks
  final TextEditingController _taskController = TextEditingController();

  // Method to add a task and update the state
  void _addTask(String taskName) {
    if (taskName.isEmpty) return; // Prevent adding empty tasks

    setState(() {
      _tasks.add(Task(name: taskName, isCompleted: false));
    });

    _taskController.clear(); // Clear the input field after adding
  }

  // Method to toggle task completion and update the state
  void _toggleCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  // Method to remove a task and update the state
  void _removeTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter task name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTask(_taskController.text),
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: TaskList(
                tasks: _tasks,
                onToggleCompletion: _toggleCompletion,
                onDeleteTask: _removeTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TaskList widget to display tasks
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggleCompletion;
  final Function(Task) onDeleteTask;

  TaskList({
    required this.tasks,
    required this.onToggleCompletion,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              onToggleCompletion(task); // Update completion state
            },
          ),
          title: Text(
            task.name,
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              onDeleteTask(task); // Remove the task
            },
          ),
        );
      },
    );
  }
}

// Task model
class Task {
  String name;
  bool isCompleted;

  Task({required this.name, required this.isCompleted});
}
