import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/screens/channels.dart';
import 'package:humanchat_frontend/utils/go.dart';
import 'package:humanchat_frontend/screens/sign_up.dart';
import 'package:humanchat_frontend/states/sign_up_state.dart';
import 'package:humanchat_frontend/utils/exceptions/entity_exception.dart';
import 'package:humanchat_frontend/utils/exceptions/serverside_exception.dart';
import 'package:humanchat_frontend/utils/validate.dart';
import 'package:humanchat_frontend/widgets/error_dialog.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/widgets/interactive_button.dart';
import 'package:humanchat_frontend/widgets/title.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  late final AuthController _authController;
  late final SignUpState _userSignUpInfo;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final RxBool emailValid;
  final passwordValid = false.obs;
  get _canContinue => emailValid.value && passwordValid.value;

  final immediateEmailErrorMessage = RxnString();
  final immediatePasswordErrorMessage = RxnString();
  final lastEmailInput = ''.obs;
  final lastPasswordInput = ''.obs;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController());
    _userSignUpInfo = Get.put(SignUpState());
    if (_userSignUpInfo.completedObs.value) {
      _emailController.text = _userSignUpInfo.emailObs.value;
      passwordFocusNode.requestFocus();
    }
    emailValid = (validateEmail(_emailController.text)?.isEmpty ?? true).obs;
  }

  String? checkEmailEx(String email) {
    if (email == lastEmailInput.value) {
      return null;
    }
    immediateEmailErrorMessage.value = null;
    lastEmailInput.value = email;
    return validateEmail(email);
  }

  String? checkPasswordEx(String password) {
    if (password == lastPasswordInput.value) {
      return null;
    }
    immediatePasswordErrorMessage.value = null;
    lastPasswordInput.value = password;
    return validatePassword(password);
  }

  Future<void> _login() async {
    if (!_canContinue) {
      return;
    }
    try {
      await _authController.login(email: _emailController.text, password: _passwordController.text);
      Go.offUntil(() => ChannelScreen());
    } on ClientSideException catch (e) {
      if (e.statusCode == 404) {
        immediateEmailErrorMessage.value = e.message;
        emailValid.value = false;
        emailFocusNode.requestFocus();
      } else if (e.statusCode == 401) {
        immediatePasswordErrorMessage.value = e.message;
        passwordValid.value = false;
        passwordFocusNode.requestFocus();
      }
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
                  initialText: _emailController.text,
                  focusNode: emailFocusNode,
                  // description: '',
                  validator: validateWithReactive(emailValid, checkEmailEx),
                  errorMessage: immediateEmailErrorMessage.value,
              )),
              Obx(() => FormInputField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: const Icon(Icons.password),
                  focusNode: passwordFocusNode,
                  isPassword: true,
                  validator: validateWithReactive(passwordValid, checkPasswordEx),
                  errorMessage: immediatePasswordErrorMessage.value,
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
