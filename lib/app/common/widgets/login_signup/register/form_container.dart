// app/common/widgets/login_signup/register/form_container.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/login/register_button.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/register/sign_up_form.dart';
import 'package:listatarefa1/app/features/auth/presentation/auth_controller.dart';
import 'package:listatarefa1/app/features/auth/presentation/login_page.dart';
import 'package:listatarefa1/app/utils/constants/sizes.dart';
import 'package:listatarefa1/app/utils/helpers/helper_functions.dart';
import '../form_divider.dart';

class BuildFormContainer extends StatelessWidget {
  const BuildFormContainer({
    super.key,
    required this.formKey,
    required this.signUpNameController,
    required this.confirmPasswordController,
    required this.signUpEmailController,
    required this.signUpPasswordController,
    required this.authController,
    required this.context,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController signUpNameController;
  final TextEditingController confirmPasswordController;
  final TextEditingController signUpEmailController;
  final TextEditingController signUpPasswordController;
  final AuthController authController;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: screenHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.07),
            // Formulário de Registro
            SignUpForm(
              formKey: formKey,
              usernameController: signUpNameController,
              confirmPasswordController: confirmPasswordController,
              emailController: signUpEmailController,
              passwordController: signUpPasswordController,
            ),
            SizedBox(height: screenHeight * 0.05),
            // Botão de Registro
            Obx(
              () => authController.isLoading
                  ? const CircularProgressIndicator(color: Colors.deepPurple)
                  : RegisterButton(
                      formKey: formKey,
                      nameController: signUpNameController,
                      emailController: signUpEmailController,
                      passwordController: signUpPasswordController,
                      confirmPasswordController: confirmPasswordController,
                      authController: authController,
                      showError: (String message) {},
                    ),
            ),
            const SizedBox(height: 48),

            const TFormDivider(dividerText: 'Or'),

            const SizedBox(height: TSizes.defaultSpace),

            SizedBox(height: screenHeight * 0.05),
            // Navegar para a tela de login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    THelperFunctions.navigateToScreen(
                      context,
                      const LoginScreen(),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
