import 'package:humanchat_frontend/utils/exceptions/response_exception.dart';

class ServersideException extends ResponseException implements Exception {
  @override
  final String message;
  @override
  final int statusCode;
  ServersideException(this.message, this.statusCode);
  @override
  String toString() => message;
}