// app/common/widgets/login_signup/login/register_button.dart
import 'package:flutter/material.dart';
import '../../../../features/auth/presentation/auth_controller.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.authController,
    required this.showError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AuthController authController;
  final Function(String) showError;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          authController.signUp(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
        }
      },
      child: const Text('Register'),
    );
  }
}