import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  Future<User> signUpWithEmail(String email, String password, String name) {
    return repository.signUpWithEmail(email, password, name);
  }

  Future<User> signInWithEmail(String email, String password) {
    return repository.signInWithEmail(email, password);
  }

  Future<User> signInWithGoogle() {
    return repository.signInWithGoogle();
  }

  Future<void> signOut() {
    return repository.signOut();
  }

  Future<User?> getCurrentUser() {
    return repository.getCurrentUser();
  }
}
