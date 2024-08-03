import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app_flutter/utils/shared_prefs.dart';

class NavBar extends StatelessWidget {
  final String name;

  const NavBar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            direction: Axis.horizontal,
            alignment: constraints.maxWidth < 430 ? WrapAlignment.center : WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Welcome back, $name'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await SharedPrefs().prefs.remove('task_app_token');
                      context.go('/sign-in');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/add-task'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Add task',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ]
              ),
            ],
          );
        }
      ),
    );
  }
}
