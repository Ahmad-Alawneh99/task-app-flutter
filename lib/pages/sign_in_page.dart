import 'package:flutter/material.dart';
import 'package:task_app_flutter/components/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(child: SignInForm());
  }
}
