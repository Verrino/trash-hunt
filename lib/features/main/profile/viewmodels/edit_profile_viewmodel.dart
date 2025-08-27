import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';

class EditProfileViewModel extends ChangeNotifier {
  final HunterRepositoryImpl _hunterService;

  EditProfileViewModel(this._hunterService);

  Hunter? _hunter;
  Hunter? get hunter => _hunter;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getHunter() async {
    _set(loading: true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      _hunter = await _hunterService.getHunter(uid!);
    } catch(e) {
      _set(loading: false, error: e.toString());
    } finally {
      _set(loading: false);
    }
  }

  Future<bool> editHunter(String username, DateTime tanggalLahir) async {
    _set(loading: true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await _hunterService.updateHunter(userId: uid!, username: username, birthDate: tanggalLahir);
      _hunter = await _hunterService.getHunter(uid);
      _set(loading: false);
      return true;
    } catch (e) {
      _set(loading: false, error: e.toString());
      return false;
    }
  }

  void _set({bool? loading, String? error}) {
    if (loading != null) _isLoading = loading;
    if (error != null) _errorMessage = error;
    notifyListeners();
  }
}