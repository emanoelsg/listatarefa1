// app/common/widgets/login_signup/login/form_container.dart

import 'package:flutter/material.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/form_divider.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/login/login_buttom.dart';
import 'package:listatarefa1/app/common/widgets/login_signup/login/login_form.dart';
import 'package:listatarefa1/app/features/auth/presentation/auth_controller.dart';
import 'package:listatarefa1/app/features/auth/presentation/register_screen.dart';
import 'package:listatarefa1/app/utils/constants/sizes.dart';
import 'package:listatarefa1/app/utils/helpers/helper_functions.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController loginEmailController,
    required TextEditingController loginPasswordController,
    required this.authController,
  }) : _formKey = formKey,
       _loginEmailController = loginEmailController,
       _loginPasswordController = loginPasswordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _loginEmailController;
  final TextEditingController _loginPasswordController;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),

            //Email and Password Login System
            LoginForm(
              formKey: _formKey,
              emailController: _loginEmailController,
              passwordController: _loginPasswordController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            //Login Button
            LoginButtom(
              authController: authController,
              formKey: _formKey,
              loginEmailController: _loginEmailController,
              loginPasswordController: _loginPasswordController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.075),

            const TFormDivider(dividerText: 'Or'),

            const SizedBox(height: TSizes.defaultSpace),

            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    THelperFunctions.navigateToScreen(
                      context,
                      const RegisterScreen(),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
