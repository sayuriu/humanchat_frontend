import 'package:get/get.dart';
import 'package:humanchat_frontend/utils/go.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/utils/exceptions/entity_exception.dart';
import 'package:humanchat_frontend/utils/exceptions/response_exception.dart';
import 'package:humanchat_frontend/utils/exceptions/serverside_exception.dart';
import 'package:humanchat_frontend/widgets/error_dialog.dart';

Never _throwError<T>(Response<T> response) {
  if (399 < response.statusCode! && response.statusCode! < 500) {
    throw ClientSideException((response.body as Map<String, dynamic>)['message'], response.statusCode!);
  } else if (499 < response.statusCode! && response.statusCode! < 600) {
    throw ServersideException((response.body as Map<String, dynamic>)['message'], response.statusCode!);
  }
  throw Exception(response.statusText);
}

throwOnResponseError<T>(Response<T> response) {
  if (response.hasError) _throwError<T>(response);
}

handleResponseError(ResponseException exception) {
  if (exception is ClientSideException) {
    if (exception.statusCode == 401) {
      Get.dialog(
        barrierDismissible: false,
        ErrorDialog(
          message: "Your session has expired. Please log in again.",
          onConfirm: () => Go.offUntil(() => const WelcomeScreen()),
        )
      );
    }
  } else if (exception is ServersideException) {
    Get.dialog(
      ErrorDialog(
        message: "It appears that our servers are having some issues. Please try again later.",
        additionalInformation: '(${exception.statusCode.toString()}) ${exception.message}',
      )
    );
  }
}