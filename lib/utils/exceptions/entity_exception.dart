import 'package:humanchat_frontend/utils/exceptions/response_exception.dart';

class ClientSideException extends ResponseException implements Exception {
  @override
  final String message;
  @override
  final int statusCode;
  ClientSideException(this.message, this.statusCode);
  @override
  String toString() => message;
}