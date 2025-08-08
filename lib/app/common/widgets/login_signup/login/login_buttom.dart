// app/common/widgets/login_signup/login/login_buttom.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/presentation/auth_controller.dart';

class LoginButtom extends StatelessWidget {
  const LoginButtom({
    super.key,
    required this.authController,
    required GlobalKey<FormState> formKey,
    required TextEditingController loginEmailController,
    required TextEditingController loginPasswordController,
  }) : _formKey = formKey, _loginEmailController = loginEmailController, _loginPasswordController = loginPasswordController;

  final AuthController authController;
  final GlobalKey<FormState> _formKey;
  final TextEditingController _loginEmailController;
  final TextEditingController _loginPasswordController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => authController.isLoading == true
          ? const CircularProgressIndicator(
              color: Colors.deepPurple,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size.fromHeight(30),
              ),
              child: const Text('Login'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // continuar com o fluxo de registro
                  authController.loginWithEmail(
                     _loginEmailController.text,
                    _loginPasswordController.text,
                  );
                }
              },
            ),
    );
  }
}
