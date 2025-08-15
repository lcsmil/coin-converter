class AppException implements Exception {
  final String message;
  final Failure failure;

  AppException(this.message, this.failure);

  @override
  String toString() => message;
}

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class GenericFailure extends Failure {
  const GenericFailure(super.message);
}
