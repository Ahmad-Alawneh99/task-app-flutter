import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app_flutter/components/nav_bar.dart';
import 'package:task_app_flutter/components/task_list.dart';
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

    final tasksFuture = http.get(
      Uri.parse('http://localhost:3030/tasks/getAll'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final userFuture = http.get(
      Uri.parse('http://localhost:3030/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final apiResponses = await Future.wait([
      tasksFuture,
      userFuture,
    ] as Iterable<Future>);

    final formattedTasksResponse = json.decode(apiResponses[0].body);
    final formattedUserResponse = json.decode(apiResponses[1].body);

    return {
      'tasks': formattedTasksResponse['tasks'] ?? [],
      'user': formattedUserResponse['user'] ?? {},
    };
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
                      NavBar(name: snapshot.data['user']['name']),
                      const SizedBox(height: 16,),
                      TaskList(tasks: snapshot.data['tasks']),
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
