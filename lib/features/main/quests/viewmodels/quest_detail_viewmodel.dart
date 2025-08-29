import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';
import 'package:trash_hunt/features/main/services/quest_repository_impl.dart';

class QuestDetailViewModel extends ChangeNotifier {
  final HunterRepositoryImpl _hunterRepository;
  final QuestRepositoryImpl _questRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _progress = 0;
  int get progress => _progress;

  String? _reasonMessage;
  String? get reasonMessage => _reasonMessage;

  QuestDetailViewModel(this._hunterRepository, this._questRepository);

  Future<bool> submitQuest(File imageFile, Map<String, dynamic> questData) async {
    _set(isLoading: true);
    final response = await _questRepository.submitQuest(imageFile, questData);
    print(response);
    var reason = null;
    if (response[0] == false) {
      reason = response[2];
    }
    _set(isLoading: false, progress: response[1], reason: reason);

    if (progress >= questData['target_count']) {
      return true;
    }
    return false;
  }

  void _set({bool? isLoading, String? reason, int? progress}) {
    if(isLoading != null) _isLoading = isLoading;
    if(progress != null) _progress = progress;
    if(reason != null) {
      _reasonMessage = reason;
    } else {
      _reasonMessage = null;
    }
    notifyListeners();
  }

  void set(String? reason) {
    if (reason != null) {
      _reasonMessage = reason;
    } else {
      _reasonMessage = null;
    }
    notifyListeners();
  }
}