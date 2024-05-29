import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/utils/go.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/states/sign_up_state.dart';
import 'package:humanchat_frontend/utils/exceptions/entity_exception.dart';
import 'package:humanchat_frontend/utils/exceptions/serverside_exception.dart';
import 'package:humanchat_frontend/widgets/error_dialog.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/utils/validate.dart';
import 'package:humanchat_frontend/widgets/interactive_button.dart';
import 'package:humanchat_frontend/widgets/title.dart';

class SignUpScreenTheSequel extends StatelessWidget {
  final _authController = Get.put(AuthController());
  final _signUpState = Get.put(SignUpState());
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();

  final usernameValid = false.obs;
  final displayNameValid = false.obs;
  final checking = false.obs;
  final immediateUsernameErrorMessage = RxnString();

  final lastUsernameInput = ''.obs;

  String? checkUsernameEx(String username) {
    if (username == lastUsernameInput.value) {
      return null;
    }
    immediateUsernameErrorMessage.value = null;
    lastUsernameInput.value = username;
    return validateUsername(username);
  }

  final userNameFocusNode = FocusNode();

  SignUpScreenTheSequel({super.key});

  get _canContinue => usernameValid.value;

  _signUp() async {
    if (!_canContinue) return;
    checking.value = true;
    _signUpState.setName(username: _usernameController.text, displayName: _displayNameController.text);
    try {
      await _authController.signUp(
        email: _signUpState.emailObs.value,
        password: _signUpState.passwordObs.value,
        username: _signUpState.usernameObs.value,
        displayName: _signUpState.displayNameObs.value
      );
    } on ClientSideException catch (e) {
      if (e.statusCode == 400) {
        immediateUsernameErrorMessage.value = e.message;
        usernameValid.value = false;
        userNameFocusNode.requestFocus();
      }
      checking.value = false;
      return;
    } on ServersideException catch (e, _) {
      Get.dialog(ErrorDialog(message: e.message, additionalInformation: '(${e.statusCode.toString()}) ${e.message}'));
      checking.value = false;
      return;
    } catch (e) {
      Get.dialog(ErrorDialog(message: 'Critical error.', additionalInformation: e.toString()));
      checking.value = false;
      return;
    }
    checking.value = false;
    _signUpState.completedObs.value = true;
    Get.dialog(AlertDialog(
      title: const Text('Sign up sucessful'),
      content: const Text('You will now be redirected to the welcome screen.'),
      actions: [
        TextButton(
          onPressed: () => Go.offUntil(() => WelcomeScreen()),
          child: const Text('Continue'),
        )
      ],
    ));
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
                  Text('How should you be known?'),
                ]
              ),
              const Gap(24),
              Obx(() => FormInputField(
                  controller: _usernameController,
                  label: 'Username',
                  focusNode: userNameFocusNode,
                  validator:  validateWithReactive(usernameValid, checkUsernameEx),
                  errorMessage: immediateUsernameErrorMessage.value,
                  icon: const Icon(Icons.person),
              )),
              FormInputField(
                  controller: _displayNameController,
                  label: 'Display name',
                  description: 'Optional',
                  validator: validateWithReactive(displayNameValid, validateDisplayName),
                  icon: const Icon(Icons.card_membership)
              ),
              const Gap(24),
              Obx(() =>
                InteractiveButton(
                  onPressed: _signUp,
                  disabled: !_canContinue || checking.value,
                  label: 'Continue',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  icon: checking.value ? const Icon(Icons.hourglass_bottom) : const Icon(Icons.arrow_forward),
                ),
              ),
              const Gap(24),
              InteractiveButton(
                onPressed: () => Get.back(),
                disabled: checking.value,
                label: 'Back',
                borderThickness: 1,
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer()
            ],
          ),
        )
      ),
    );
  }
}