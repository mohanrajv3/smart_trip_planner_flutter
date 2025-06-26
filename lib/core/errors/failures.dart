abstract class Failure {
  final String message;

  Failure(this.message);
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class StorageFailure extends Failure {
  StorageFailure(String message) : super(message);
}
