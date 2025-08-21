import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash_hunt/core/domain/entities/app_user.dart';

class SessionManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? get currentUser =>
      _auth.currentUser != null ? AppUser.fromFirebaseUser(_auth.currentUser) : null;

  Future<void> signOut() async => await _auth.signOut();
}