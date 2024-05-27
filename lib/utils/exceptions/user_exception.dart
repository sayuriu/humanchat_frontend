class UserException implements Exception {
  final String message;
  final int statusCode;
  UserException(this.message, this.statusCode);
  @override
  String toString() => message;
}