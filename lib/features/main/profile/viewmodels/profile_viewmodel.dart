import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
import 'package:trash_hunt/features/auth/services/auth_repository_impl.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';

class ProfileViewModel extends ChangeNotifier {
  final HunterRepositoryImpl _hunterService;
  final AuthRepositoryImpl _authService;

  ProfileViewModel(this._hunterService, this._authService);

  Hunter? _hunter;
  Hunter? get hunter => _hunter;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getHunter() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      _hunter = await _hunterService.getHunter(uid!);
    } catch(e) {
      _set(error: e.toString());
      debugPrint("Error fetching hunter: $e");
    } finally {
      _set();
    }
  }

  int expToNext(int level) {
    return _hunterService.expToNext(level);
  }

  Future<bool> signOut() async {
    await _authService.signOut();
    _set();
    return true;
  }

  void _set({String? error}) {
    if (error != null) _errorMessage = error;
    notifyListeners();
  }
}