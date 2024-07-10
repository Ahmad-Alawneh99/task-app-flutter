import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/add_task_form.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(child: AddTaskForm());
  }
}
