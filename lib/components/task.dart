import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/box.dart';

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

  @override
  void initState() {
    super.initState();
    completed = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.yellow),
      child: Box(
        maxWidth: 280,
        maxHeight: 212,
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
              onChanged: (value) {
                setState(() {
                  // @TODO: Call API to update
                  completed = value ?? false;
                });
              },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () => {},
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
      ),
    );
  }
}
