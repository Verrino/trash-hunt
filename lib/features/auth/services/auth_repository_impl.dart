import "package:firebase_auth/firebase_auth.dart";
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/domain/repositories/auth_repository.dart';
import '../../../core/domain/entities/app_user.dart';

class AuthRepositoryImpl extends AuthRepository {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthRepositoryImpl();

  @override
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

      return cred.user != null ? AppUser.fromFirebaseUser(cred.user) : null;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
       throw Exception('Google sign-in failed');
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      return user != null ? AppUser.fromFirebaseUser(user) : null;
    } catch (e) {
      print(e.toString());
    }

    return null;

  }

  @override
  Future<AppUser?> signUpWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);

      return cred.user != null ? AppUser.fromFirebaseUser(cred.user) : null;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }
}
