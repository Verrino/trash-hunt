import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithEmail(String email, String password);
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> signUpWithEmail(String email, String password);

}