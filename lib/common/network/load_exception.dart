sealed class LoadException implements Exception {
  const LoadException();
}

final class NetworkLoadException extends LoadException {
  const NetworkLoadException();
}

final class ServerLoadException extends LoadException {
  final int? statusCode;
  const ServerLoadException([this.statusCode]);
}

final class NotFoundLoadException extends LoadException {
  const NotFoundLoadException();
}