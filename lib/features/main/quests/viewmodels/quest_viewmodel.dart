import 'package:firebase_auth/firebase_auth.dart';
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

    final hunter = await _questService.hunterService.getHunter(
      FirebaseAuth.instance.currentUser?.uid ?? "",
    );
    final dailyQuestsProgress = hunter?.dailyQuests ?? [];

    List<Map<String, dynamic>> result = [];
    for (final quest in quests) {
      final progressData = dailyQuestsProgress.firstWhere(
        (q) => q['quest_id'] == quest.questId,
        orElse: () => <String, dynamic>{},
      );
      final progress = progressData['progress'] ?? 0;
      final isDone = progressData['is_done'] ?? false;
      final questMap = quest.toMap();
      questMap['progress'] = progress;
      questMap['is_done'] = isDone;
      result.add(questMap);
    }

    _set();
    return result;
  }

  void _set({String? error}) {
    if (error != null) _errorMessage = error;
    notifyListeners();
  }
}