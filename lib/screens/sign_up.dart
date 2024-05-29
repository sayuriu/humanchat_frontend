import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/utils/go.dart';
import 'package:humanchat_frontend/screens/sign_up_the_sequel.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/states/sign_up_state.dart';
import 'package:humanchat_frontend/utils/debounce.dart';
import 'package:humanchat_frontend/utils/exceptions/response_exception.dart';
import 'package:humanchat_frontend/utils/response_error.dart';
import 'package:humanchat_frontend/utils/validate.dart';
import 'package:humanchat_frontend/widgets/error_dialog.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/widgets/interactive_button.dart';
import 'package:humanchat_frontend/widgets/title.dart';

class SignUpScreen extends StatelessWidget {
  final _authController = Get.put(AuthController());
  final _signUpState = Get.put(SignUpState());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final immediateEmailErrorMessage = RxnString();
  final emailValid = false.obs;
  final passwordValid = false.obs;
  final confirmPasswordValid = false.obs;
  final checking = false.obs;
  get _canContinue => emailValid.value && passwordValid.value && confirmPasswordValid.value;

  final Debounce _debounce = Debounce(debounceTimeMillis: 500);
  final emailFocusNode = FocusNode();
  final lastEmailInput = ''.obs;

  SignUpScreen({super.key});

  String? checkEmailEx(String email) {
    if (email == lastEmailInput.value) {
      return null;
    }
    immediateEmailErrorMessage.value = null;
    lastEmailInput.value = email;
    return validateEmail(email);
  }

  void _signUp() async {
    if (!_canContinue) return;
    checking.value = true;
    try {
      final exists = await _debounce.execute(
        () => _authController.checkEmail(email: _emailController.text)
      );
      checking.value = false;
      if (exists) {
        immediateEmailErrorMessage.value = 'Email already exists';
        emailValid.value = false;
        emailFocusNode.requestFocus();
        return;
      }
    } on ResponseException catch (e) {
      handleResponseError(e);
    }
    _signUpState.setLoginInformation(email: _emailController.text, password: _passwordController.text);
    Go.to(() => SignUpScreenTheSequel());
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
                  Text('Welcome to realm of bantering.'),
                ]
              ),
              const Gap(24),
              Obx(() =>  FormInputField(
                controller: _emailController,
                label: 'Email',
                icon: const Icon(Icons.email_outlined),
                focusNode: emailFocusNode,
                // description: '',
                validator:  validateWithReactive(emailValid, checkEmailEx),
                errorMessage: immediateEmailErrorMessage.value,
              )),
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
                  validator: validateWithReactive(confirmPasswordValid, _validateConfirmPassword),
              ),
              const Gap(24),
              Obx(() =>
                InteractiveButton(
                  onPressed: _signUp, // Go.to(() => SignUpScreenTheSequel())
                  disabled: !_canContinue || checking.value,
                  label: checking.value ? 'Checking...' : 'Continue',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  icon: checking.value ? const Icon(Icons.hourglass_empty) : const Icon(Icons.arrow_forward),
                ),
              ),
              const Gap(12),
              const Text('Have an account?'),
              const Gap(4),
              InteractiveButton(
                onPressed: () => Go.offUntil(() => WelcomeScreen()),
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
