import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/screens/go.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/utils/validate.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/widgets/interactive_button.dart';
import 'package:humanchat_frontend/widgets/title.dart';

class SignUpScreen extends StatelessWidget {
  final _authController = Get.put(AuthController());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var emailValid = false.obs;
  var passwordValid = false.obs;
  var confirmPasswordValid = false.obs;

  void _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text != _confirmPasswordController.text) {
      return;
    }
    // await _authController.signUp(email: _emailController.text,password:  _passwordController.text);
  }

  canContinue() {
    return emailValid.value && passwordValid.value && confirmPasswordValid.value;
  }

  String? _validateConfirmPassword(String password) {
    confirmPasswordValid.value = false;
    if (password != _passwordController.text) {
      return 'Passwords do not match';
    }
    confirmPasswordValid.value = true;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              const Hero(
                tag: 'welcome_title',
                child: Material(
                  type: MaterialType.transparency,
                  animationDuration: Duration(milliseconds: 300),
                  child: AppTitle(),
                )
              ),
              const SizedBox(height: 24),
              FormInputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: const Icon(Icons.email_outlined),
                  // description: '',
                  validator:  validateWithReactive(emailValid, validateEmail)
              ),
              FormInputField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: const Icon(Icons.password),
                  isPassword: true,
                  validator: validateWithReactive(passwordValid, validatePassword)
              ),
              FormInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm password',
                  icon: const Icon(Icons.password),
                  isPassword: true,
                  validator: validateWithReactive(confirmPasswordValid, _validateConfirmPassword)
              ),
              const SizedBox(height: 24),
              Obx(() =>
                InteractiveButton(
                  onPressed: _signUp,
                  disabled: !canContinue(),
                  label: 'Continue',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Have an account?'),
              const SizedBox(height: 4),
              InteractiveButton(
                onPressed: () => Go.off(() => WelcomeScreen()),
                label: 'Login',
                reactiveBorder: true,
                textColor: Theme.of(context).colorScheme.primary,
                borderThickness: 1,
                icon: const Icon(Icons.login),
              ),
              const Spacer(),
            ],
          ),
        )
      ),
    );
  }
}
