import 'package:flutter/material.dart';
import 'package:trash_hunt/core/domain/entities/quest.dart';
import 'package:trash_hunt/features/main/services/quest_repository_impl.dart';

class QuestViewModel extends ChangeNotifier {
  final QuestRepositoryImpl _questService;
  QuestViewModel(this._questService);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<List<Map<String, dynamic>>> getDailyQuests() async {
    final List<Quest> quests = await _questService.getDailyQuests();
    _set();
    return quests.map((e) => e.toMap()).toList();
  }

  void _set({String? error}) {
    if (error != null) _errorMessage = error;
    notifyListeners();
  }
}