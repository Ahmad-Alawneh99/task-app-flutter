import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/box.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:task_app_flutter/utils/shared_prefs.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isErrored = false;
  String errorMessage = 'Unknown error';
  bool isFetching = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String?> _getToken () {
    final existingToken = SharedPrefs().prefs.getString('task_app_token');
    return Future.value(existingToken);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Box(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Sign up',
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
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
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
                              'name': nameController.text,
                              'email': emailController.text,
                              'password': passwordController.text,
                            });

                            final response = await http.post(
                              Uri.parse('http://localhost:3030/users/sign-up'),
                              body: body,
                              headers: {
                                'Content-Type': 'application/json'
                              }
                            );

                            final formattedResponse = json.decode(response.body);

                            if (formattedResponse['success']) {
                              await SharedPrefs().prefs.setString('task_app_token', formattedResponse['token']);
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
                          'Sign up',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Have an account? '),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        child: const Text(
                          'Sign in here',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          context.go('/sign-in');
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/');
          });
          return Container();
        } else {
          return Container();
        }
      }
    );
  }
}