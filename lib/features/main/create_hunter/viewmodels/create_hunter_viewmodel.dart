import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';

class CreateHunterViewModel extends ChangeNotifier {
  final HunterRepositoryImpl _hunterService;

  CreateHunterViewModel(this._hunterService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> registerHunter(String username, DateTime tanggalLahir) async {
    _set(loading: true, error: null);
    var success = false;

    try {
      if (username.trim().isEmpty) {
        throw("Username wajib diisi");
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;

      success = await _hunterService.addHunter(userId!, username, tanggalLahir);
    }
    catch (e) {
      _set(loading: false, error: e.toString());
    }
    finally {
      _set(loading: false);
    }
    return success;
  }

  void _set({bool? loading, String? error}) {
    if (loading != null) _isLoading = loading;
    _errorMessage = error;
    notifyListeners();
  }
}