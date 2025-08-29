import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash_hunt/core/domain/entities/quest.dart';
import 'package:trash_hunt/core/domain/repositories/quest_repository.dart';
import 'package:trash_hunt/core/services/google_ai_service.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';

class QuestRepositoryImpl extends QuestRepository {
  final _firestore = FirebaseFirestore.instance;
  final GoogleAiService _gemini = GoogleAiService();
  final HunterRepositoryImpl hunterService = HunterRepositoryImpl();

  @override
  Future<List<Quest>> getDailyQuests() async {
    final ref = await _firestore.collection('quests').get();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (ref != null) {
      await hunterService.resetDailyQuests(userId!);

      List<Quest> allDailyQuests = ref.docs
          .where((doc) => doc.data()['quest_type'] == 'daily')
          .map((doc) => Quest.fromJson(doc.data(), doc.id))
          .toList();

      List<Quest> dailyQuests = [];
      if (await hunterService.hasAssignedQuests(userId)) {
        final assignedQuests = await hunterService.getAssignedQuests(userId);

        for (var quest in assignedQuests) {
          if (!quest['is_done']) {
            dailyQuests.add(
              allDailyQuests.firstWhere((q) => q.questId == quest['quest_id'])
            );
          }
        }
        return dailyQuests;
      } else {
        allDailyQuests.shuffle();

        // Take 3 easy quests
        dailyQuests.addAll(allDailyQuests
            .where((quest) => quest.questDifficulty == 'easy')
            .take(3));

        // Take 1 medium quests
        dailyQuests.addAll(allDailyQuests
            .where((quest) => quest.questDifficulty == 'medium')
            .take(1));

        await hunterService.assignQuestsToHunter(dailyQuests.map((e) => e.questId).toList(), userId);

        return dailyQuests;
      }
    }
    return [];
  }

  Future<List<dynamic>> submitQuest(File imageFile, Map<String, dynamic> questData) async {
    final answer = await _gemini.validateImage(imageFile, questData['trash'], questData['description']);
    final answerParts = answer.split(",");
    final uid = FirebaseAuth.instance.currentUser?.uid;

    var progress = await hunterService.getProgress(uid!, questData['quest_id']);
    print(answerParts[0] == 'true');

    final isTrash = answerParts[0] == 'true';
    final trashCount = int.tryParse(answerParts[1]) ?? 0;
    progress = progress + trashCount;

    final isCompleted = progress >= questData['target_count'];
    if (isCompleted) {
      progress = questData['target_count'];
    }

    await hunterService.updateProgress(uid, questData, progress, isCompleted);

    if (!isTrash) {
      final reason = answerParts[2];
      return [false, progress, reason];
    }

    return [isTrash, progress, null];
  }
}