class ServersideException implements Exception {
  final String message;
  final int statusCode ;
  ServersideException(this.message, this.statusCode);
  @override
  String toString() => message;
}