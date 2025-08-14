// app/features/auth/presentation/pages/register/register_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/register/register_form/form_container.dart';

import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authController = Get.find<AuthController>();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final signUpEmailController = TextEditingController();
  final signUpNameController = TextEditingController();
  final signUpPasswordController = TextEditingController();

  @override
  void dispose() {
    signUpEmailController.dispose();
    signUpNameController.dispose();
    signUpPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.07),
                  RegisterFormContainer(
                    authController: authController,
                    formKey: formKey,
                    nameController: signUpNameController,
                    emailController: signUpEmailController,
                    passwordController: signUpPasswordController,
                    confirmPasswordController: confirmPasswordController,
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
