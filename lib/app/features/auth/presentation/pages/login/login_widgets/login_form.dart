// app/features/auth/presentation/pages/login/login_widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/register/register_screen.dart';
import 'package:listatarefa1/app/utils/constants/sizes.dart';
import 'package:listatarefa1/app/utils/helpers/helper_functions.dart';

class LoginFormContainer extends StatelessWidget {
  final AuthController authController;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormContainer({
    super.key,
    required this.authController,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.06),

            /// Formulário
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter your password' : null,
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.05),

            /// Botão de Login / Loading — agora reativo de forma mais previsível
            Obx(() => _buildLoginButton()),

            SizedBox(height: height * 0.075),
            const SizedBox(height: TSizes.defaultSpace),

            /// Link para cadastro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    THelperFunctions.navigateToScreen(
                      context,
                      const RegisterPage(),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),

            SizedBox(height: height * 0.06),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    if (authController.isLoading is RxBool
        ? (authController.isLoading as RxBool).value
        : authController.isLoading) {
      return const CircularProgressIndicator(color: Colors.deepPurple);
    }

    return ElevatedButton(
      key: const Key('login_button'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          authController.loginWithEmail(
            emailController.text.trim(),
            passwordController.text,
          );
        }
      },
      child: const Text('Login'),
    );
  }
}
