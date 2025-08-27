import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../core/domain/entities/app_user.dart';
import '../services/auth_repository_impl.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepositoryImpl _authService;
  AuthViewModel(this._authService);

  AppUser? _user;
  AppUser? get user => _user;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signInWithEmail(String email, String password) async {
    _set(loading: true, error: null);

    try {
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }
      _user = await _authService.signInWithEmail(email, password);
      if (_user == null) {
        throw Exception('Login failed');
      }
      return true;
    } catch (e) {
      _set(error: e.toString());
    } finally {
      _set(loading: false);
    }

    return false;
  }

  Future<bool> signInWithGoogle() async {
    _set(loading: true, error: null);

    try {
      _user = await _authService.signInWithGoogle();
      if (_user == null) {
        throw Exception('Login with Google failed');
      }
      return true;
    } catch (e) {
      _set(error: e.toString());
    } finally {
      _set(loading: false);
    }

    return false;
  }

  Future<bool> signUpWithEmail(String email, String password, String confirmedPassword) async {
    _set(loading: true, error: null);

    try {
      if (email.trim().isEmpty || password.isEmpty || confirmedPassword.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }

      if (password != confirmedPassword) {
        throw Exception('Passwords do not match');
      }
      _user = await _authService.signUpWithEmail(email, password);
      if (_user == null) {
        throw Exception('Sign up failed');
      }
      return true;
    } catch (e) {
      _set(error: e.toString());
    } finally {
      _set(loading: false);
    }

    return false;
  }

  Future<bool> checkHunter() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return false;
    
    return await _authService.isHunterExists(uid);
  }

  void _set({bool? loading, String? error}) {
    if (loading != null) _isLoading = loading;
    _errorMessage = error;
    notifyListeners();
  }
}