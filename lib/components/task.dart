import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/box.dart';
import 'package:task_app_flutter/utils/shared_prefs.dart';

class TaskData {
  String id;
	String title;
	String? description;
	bool completed;
	String ownerId;
	int? createdAt;
	int? updatedAt;

  TaskData(
    this.id,
    this.title,
    this.description,
    this.completed,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
  );
}

class Task extends StatefulWidget {
  final TaskData task;
  final Function onDelete;
  const Task({super.key, required this.task, required this.onDelete});

  @override
  State<StatefulWidget> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late bool completed;

  void _handleUpdateTask(value) async {
    try {
      setState(() {
        completed = value ?? false;
      });
      final token = SharedPrefs().prefs.getString('task_app_token');
      final body = json.encode({
        'taskId': widget.task.id,
        'completed': value,
      });

      final response = await http.put(
        Uri.parse('http://localhost:3030/tasks/update'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final formattedResponse = json.decode(response.body);

      if (!formattedResponse['success']) {
        setState(() {
          completed = !value!;
        });
      }
    } on Exception catch (error) {
      setState(() {
        completed = !value!;
      });
      print('Failed to update task');
    }
  }

  void _handleDeleteTask() async {
    try {
      final token = SharedPrefs().prefs.getString('task_app_token');
      final response = await http.delete(
        Uri.parse('http://localhost:3030/tasks/delete/${widget.task.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final formattedResponse = json.decode(response.body);

      if (formattedResponse['success']) {
        widget.onDelete(widget.task.id);
      }
    } on Exception catch (error) {
      print('Failed to delete task');
    }
  }

  @override
  void initState() {
    super.initState();
    completed = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      maxWidth: 280,
      maxHeight: 212,
      addMargins: false,
      children: [
        Text(widget.task.title,
          style: const TextStyle(fontSize: 28),
        ),
        SizedBox(
          height: 52,
          child: Text(widget.task.description ?? '',
              style: const TextStyle(fontSize: 12),
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
          ),
        ),
        CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Completed'),
            value: completed,
            onChanged: _handleUpdateTask,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ElevatedButton(
            onPressed: _handleDeleteTask,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 40),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Delete task',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    );
  }
}
