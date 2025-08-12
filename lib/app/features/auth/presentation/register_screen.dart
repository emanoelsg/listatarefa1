// app/features/auth/presentation/register_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/register/form_container.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/register/register_header.dart';
import 'package:listatarefa1/app/features/auth/presentation/auth_controller.dart';

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
                  BuildHeader(context: context),
                  SizedBox(height: screenHeight * 0.07),
                  BuildFormContainer(
                    formKey: formKey,
                    signUpNameController: signUpNameController,
                    confirmPasswordController: confirmPasswordController,
                    signUpEmailController: signUpEmailController,
                    signUpPasswordController: signUpPasswordController,
                    authController: authController,
                    context: context,
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
