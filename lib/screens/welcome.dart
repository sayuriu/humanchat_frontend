import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/screens/go.dart';
import 'package:humanchat_frontend/screens/sign_up.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/utils/exceptions/serverside_exception.dart';
import 'package:humanchat_frontend/utils/exceptions/user_exception.dart';
import 'package:humanchat_frontend/utils/validate.dart';
import 'package:humanchat_frontend/widgets/error_dialog.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/widgets/interactive_button.dart';
import 'package:humanchat_frontend/widgets/title.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);
  final _cacheService = Get.put(CacheService());
  final _authController = Get.put(AuthController());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final emailValid = false.obs;
  final passwordValid = false.obs;
  get _canContinue => emailValid.value && passwordValid.value;

  final immediateEmailErrorMessage = ''.obs;
  final immediatePasswordErrorMessage = ''.obs;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }
    try {
      await _authController.login(email: _emailController.text, password: _passwordController.text);
      log('Login successful. Have token: ${_cacheService.token}');
    } on UserException catch (e) {
      if (e.statusCode == 404) {
        immediateEmailErrorMessage.value = e.message;
        emailValid.value = false;
      } else if (e.statusCode == 401) {
        immediatePasswordErrorMessage.value = e.message;
        passwordValid.value = false;
      }
      Get.dialog(ErrorDialog(message: e.message, additionalInformation: '(${e.statusCode.toString()}) ${e.message}'));
    } on ServersideException catch (e) {
      Get.dialog(
        ErrorDialog(
          message: 'It appears that our servers are having some issues. Please try again later.',
          additionalInformation: '(${e.statusCode.toString()}) ${e.message}',
        )
      );
      log('Error: ${e.message}');
    } catch (e) {
      log('Error: ${e.toString()}');
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
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
                  Text('Online bantering, for humans.'),
                ]
              ),
              const Gap(24),
              Obx(() => FormInputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: const Icon(Icons.email_outlined),
                  // description: '',
                  validator: validateWithReactive(emailValid, validateEmail),
                  errorMessage: immediateEmailErrorMessage.value.isEmpty
                    ? null
                    : immediateEmailErrorMessage.value,
              )),
              Obx(() => FormInputField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: const Icon(Icons.password),
                  isPassword: true,
                  validator: validateWithReactive(passwordValid, validatePassword),
                  errorMessage: immediatePasswordErrorMessage.value.isEmpty
                    ? null
                    : immediatePasswordErrorMessage.value,
              )),
              const Gap(24),
              Obx(() => InteractiveButton(
                onPressed: _login,
                disabled: !_canContinue,
                label: 'Continue',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                icon: const Icon(Icons.arrow_forward),
              )),
              const Gap(12),
              const Text('Don\'t have an account?'),
              const Gap(4),
              InteractiveButton(
                onPressed: () => Go.offUntil(() => SignUpScreen()),
                label: 'Sign up',
                reactiveBorder: true,
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
