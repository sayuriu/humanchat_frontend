import 'package:get/get.dart';


class SignUpState extends GetxController {
  var emailObs = ''.obs;
  var passwordObs = ''.obs;
  var usernameObs = ''.obs;
  var completedObs = false.obs;
  var displayNameObs = RxnString(null);

  void setLoginInformation({required email, required password}) {
    emailObs.value = email;
    passwordObs.value = password;
  }

  void setName({required String username, required String displayName}) {
    usernameObs.value = username;
    displayNameObs.value = displayName;
  }

  void clearPassword() {
    passwordObs.value = '';
  }
}
