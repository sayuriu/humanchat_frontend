import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/screens/go.dart';
import 'package:humanchat_frontend/screens/sign_up.dart';
import 'package:humanchat_frontend/utils/validate.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/widgets/interactive_button.dart';
import 'package:humanchat_frontend/widgets/title.dart';

class WelcomeScreen extends StatelessWidget {

  WelcomeScreen({Key? key}) : super(key: key);
  final _authController = Get.put(AuthController());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final emailValid = false.obs;
  final passwordValid = false.obs;


  get _canContinue => emailValid.value && passwordValid.value;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }
    try {
      await _authController.login(email: _emailController.text, password: _passwordController.text);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTitle(),
                    ],
                  ),
                )
              ),
              const SizedBox(height: 24),
              FormInputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: const Icon(Icons.email_outlined),
                  // description: '',
                  validator: validateWithReactive(emailValid, validateEmail)
              ),
              FormInputField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: const Icon(Icons.password),
                  isPassword: true,
                  validator: validateWithReactive(passwordValid, validatePassword)
              ),
              const SizedBox(height: 24),
              Obx(() => InteractiveButton(
                onPressed: _login,
                disabled: !_canContinue,
                label: 'Continue',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                icon: const Icon(Icons.arrow_forward),
              )),
              const SizedBox(height: 12),
              const Text('Don\'t have an account?'),
              const SizedBox(height: 4),
              InteractiveButton(
                onPressed: () => Go.to(() => SignUpScreen()),
                label: 'Sign up',
                reactiveBorder: true,
                textColor: Theme.of(context).colorScheme.primary,
                borderThickness: 1,
                icon: const Icon(Icons.person_add),
              ),
              const Spacer(),
            ],
          ),
        )
      ),
    );
  }
}
