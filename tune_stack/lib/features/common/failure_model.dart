class Failure {
  const Failure({required this.message, this.statusCode, this.stackTrace});
  final String message;
  final int? statusCode;
  final StackTrace? stackTrace;
}
