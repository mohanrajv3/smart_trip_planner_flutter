import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/user.dart';

class AuthService {
  final AuthRemoteDataSource dataSource;

  AuthService(this.dataSource);

  Future<User> signUpWithEmail(String email, String password, String name) {
    return dataSource.signUpWithEmail(email, password, name);
  }

  Future<User> signInWithEmail(String email, String password) {
    return dataSource.signInWithEmail(email, password);
  }

  Future<User> signInWithGoogle() {
    return dataSource.signInWithGoogle();
  }

  Future<void> signOut() {
    return dataSource.signOut();
  }

  Future<User?> getCurrentUser() {
    return dataSource.getCurrentUser();
  }
}
