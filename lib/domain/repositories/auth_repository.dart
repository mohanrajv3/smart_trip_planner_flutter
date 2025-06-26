import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUpWithEmail(String email, String password, String name);
  Future<User> signInWithEmail(String email, String password);
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<User?> getCurrentUser();
}
