import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app_flutter/pages/add_task_page.dart';
import 'package:task_app_flutter/pages/sign_in_page.dart';
import 'package:task_app_flutter/pages/sign_up_page.dart';
import 'pages/tasks_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:task_app_flutter/utils/shared_prefs.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  await SharedPrefs().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TasksPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/add-task',
        builder: (context, state) => const AddTaskPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
