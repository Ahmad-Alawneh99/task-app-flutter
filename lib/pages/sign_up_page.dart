import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(child: SignUpForm());
  }
}
