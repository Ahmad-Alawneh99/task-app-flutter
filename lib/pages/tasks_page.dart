import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app_flutter/components/task.dart';
import 'package:task_app_flutter/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

    Future<String?> _getToken () {
    final existingToken = SharedPrefs().prefs.getString('task_app_token');
    return Future.value(existingToken);
  }

  Future<dynamic> _preparePageData() async {
    final token = await _getToken();
    if (token == null || token == '') {
      return null;
    }

    final tasksResponse = await http.get(
      Uri.parse('http://localhost:3030/tasks/getAll'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final formattedTasksResponse = json.decode(tasksResponse.body);

    final userResponse = await http.get(
      Uri.parse('http://localhost:3030/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final formattedUserResponse = json.decode(userResponse.body);

    return {
      'tasks': formattedTasksResponse['tasks'] ?? [],
      'user': formattedUserResponse['user'] ?? {},
    };
  }

  List<TaskData> _mapTasks(List<dynamic> apiTasks) {
    return apiTasks.map((task) {
      return TaskData(task['id'], task['title'], task['description'], task['completed'], task['ownerId'], task['createdAt'], task['updatedAt']);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _preparePageData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Material(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.red),
                        constraints: const BoxConstraints(minWidth: double.infinity),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.center,
                          children: [
                            Text('Welcome back, ${snapshot.data['user']['name']}', textAlign: TextAlign.center,),
                            Text('Another test label'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 16,
                              runSpacing: 16,
                              children: _mapTasks(snapshot.data['tasks']).map((task) => Task(task: task, onDelete: () => {})).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/sign-in');
          });

          return Container();
        }
      }
    );
  }
}
