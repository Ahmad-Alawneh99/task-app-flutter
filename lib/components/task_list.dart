import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/task.dart';

class TaskList extends StatefulWidget {
  late final List<TaskData> tasks;

  List<TaskData> _mapTasks(List<dynamic> apiTasks) {
    return apiTasks.map((task) {
      return TaskData(
        task['id'],
        task['title'],
        task['description'],
        task['completed'],
        task['ownerId'],
        task['createdAt'],
        task['updatedAt']
      );
    }).toList();
  }

  TaskList({ super.key, required List<dynamic> tasks }) {
    this.tasks = _mapTasks(tasks);
  }

  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskData> tasks = [];

  void _onTaskDeleted(taskId) {
    setState(() {
      tasks = tasks.where((task) => task.id != taskId).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: tasks.isNotEmpty ?
          Wrap(
            direction: Axis.horizontal,
            spacing: 16,
            runSpacing: 16,
            children: tasks.map((task) => Task(task: task, onDelete: _onTaskDeleted)).toList(),
          ): const Center(child: Text('No tasks! Start by adding a task'),),
        ),
      ),
    );
  }
}
