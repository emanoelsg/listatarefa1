// app/features/auth/presentation/pages/login/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/login/login_widgets/form_container.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  // Login Controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //Purple Box
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topCenter,
            ),
          ),

          //
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Title
                      Text(
                        'Login',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge!.apply(color: Colors.white),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),

                      Text(
                        'Welcome Back',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.apply(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                FormContainer(
                  formKey: _formKey,
                  loginEmailController: _loginEmailController,
                  loginPasswordController: _loginPasswordController,
                  authController: authController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
