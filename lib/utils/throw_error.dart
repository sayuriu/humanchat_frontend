import 'package:get/get_connect/http/src/response/response.dart';
import 'package:humanchat_frontend/utils/exceptions/serverside_exception.dart';
import 'package:humanchat_frontend/utils/exceptions/user_exception.dart';

Never _throwError<T>(Response<T> response) {
  if (399 < response.statusCode! && response.statusCode! < 500) {
    throw UserException((response.body as Map<String, dynamic>)['message'], response.statusCode!);
  } else if (499 < response.statusCode! && response.statusCode! < 600) {
    throw ServersideException((response.body as Map<String, dynamic>)['message'], response.statusCode!);
  }
  throw Exception(response.statusText);
}

hasError<T>(Response<T> response) {
  if (response.hasError) _throwError<T>(response);
}