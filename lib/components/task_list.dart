import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/task.dart';

class TaskList extends StatefulWidget {
  final List<TaskData> tasks;

  const TaskList({ super.key, required this.tasks });

  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskData> tasks = widget.tasks;
}
