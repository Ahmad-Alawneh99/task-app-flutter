import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/box.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:task_app_flutter/utils/shared_prefs.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  bool isErrored = false;
  String errorMessage = 'Unknown error';
  bool isFetching = false;
  bool statusController = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<String?> _getToken () {
    final existingToken = SharedPrefs().prefs.getString('task_app_token');
    return Future.value(existingToken);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Box(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Add Task',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          decoration: TextDecoration.none
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Title',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description',
                          ),
                          maxLines: null,
                          minLines: 6,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Completed'),
                        value: statusController,
                        onChanged: (value) {
                          setState(() {
                            statusController = value ?? false;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: isFetching ? null: () async {
                          setState(() {
                            isFetching = true;
                          });

                          try {
                            final body = json.encode({
                              'title': titleController.text,
                              'description': descriptionController.text,
                              'completed': statusController,
                            });

                            final response = await http.post(
                              Uri.parse('http://localhost:3030/tasks/create'),
                              body: body,
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer ${snapshot.data}',
                              },
                            );

                            final formattedResponse = json.decode(response.body);

                            if (formattedResponse['success']) {
                              context.go('/');
                            } else {
                              setState(() {
                                isErrored = true;
                                errorMessage = formattedResponse['message'];
                              });
                            }
                          } on Exception catch (error) {
                            setState(() {
                              isErrored = true;
                              errorMessage = '$error';
                            });
                          }

                          setState(() {
                            isFetching = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(220, 48)
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    if (isErrored) Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ]
                ),
              ],
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