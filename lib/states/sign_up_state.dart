import 'package:get/get.dart';


class SignUpState extends GetxController {
  var emailObs = ''.obs;
  var passwordObs = ''.obs;
  var usernameObs = ''.obs;
  var displayNameObs = RxnString(null);

  void setEmailPassword({required email, required password}) {
    emailObs.value = email;
    passwordObs.value = password;
  }

  void setName({required String username, required String displayName}) {
    usernameObs.value = username;
    displayNameObs.value = displayName;
  }
}
