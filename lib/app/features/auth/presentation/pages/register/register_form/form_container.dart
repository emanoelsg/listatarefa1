// app/features/auth/presentation/pages/register/register_form/form_container.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/common/widgets/form_divider.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/login/login_page.dart';
import 'package:listatarefa1/app/utils/constants/sizes.dart';
import 'package:listatarefa1/app/utils/validators/validation.dart';

class RegisterFormContainer extends StatelessWidget {
  final AuthController authController;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterFormContainer({
    super.key,
    required this.authController,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: screenHeight),
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
            SizedBox(height: screenHeight * 0.07),

            /// Formulário
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: TValidator.validateUsername,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: emailController,
                    validator: TValidator.validateEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: TValidator.validatePassword,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) => TValidator.validateConfirmPassword(
                      password: passwordController.text,
                      confirmPassword: value,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            /// Botão ou Loading
            Obx(() => _buildRegisterButton()),

            const SizedBox(height: 48),
            const TFormDivider(dividerText: 'Or'),
            const SizedBox(height: TSizes.defaultSpace),
            SizedBox(height: screenHeight * 0.05),

            /// Link para login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    final isLoading = authController.isLoading;

    return ElevatedButton(
      key: const Key('register_button'),
      onPressed: isLoading
          ? null
          : () {
              if (formKey.currentState?.validate() ?? false) {
                authController.signUp(
                  nameController.text.trim(),
                  emailController.text.trim(),
                  passwordController.text,
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size.fromHeight(48),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Register'),
    );
  }
}
