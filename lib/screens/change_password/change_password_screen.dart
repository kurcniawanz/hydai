import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/change_password_form.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String routeName = "/change_password";

  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("My Profile", style: headingStyle),
                  const SizedBox(height: 16),
                  const ChangePasswordForm(),
                  const SizedBox(height: 30),
                  Text(
                    "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
