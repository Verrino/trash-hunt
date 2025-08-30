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
    if (ref != null && userId != null) {
      List<Quest> allDailyQuests = ref.docs
          .where((doc) => doc.data()['quest_type'] == 'daily')
          .map((doc) => Quest.fromJson(doc.data(), doc.id))
          .toList();

      List<Quest> dailyQuests = [];

      final hasAssigned = await hunterService.hasAssignedQuests(userId);
      if (hasAssigned) {
        await hunterService.resetDailyQuests(userId);

        final stillHasAssigned = await hunterService.hasAssignedQuests(userId);
        if (stillHasAssigned) {
          final assignedQuests = await hunterService.getAssignedQuests(userId);
          for (var quest in assignedQuests) {
            if (!quest['is_done']) {
              final found = allDailyQuests.firstWhere(
                (q) => q.questId == quest['quest_id'],
                orElse: () => Quest.empty(),
              );
              if (found.questId.isNotEmpty) dailyQuests.add(found);
            }
          }
          return dailyQuests;
        }
      }

      allDailyQuests.shuffle();

      // Take 3 easy quests
      dailyQuests.addAll(allDailyQuests
          .where((quest) => quest.questDifficulty == 'easy')
          .take(3));

      // Take 1 medium quest
      dailyQuests.addAll(allDailyQuests
          .where((quest) => quest.questDifficulty == 'medium')
          .take(1));

      await hunterService.assignQuestsToHunter(
        dailyQuests.map((e) => e.questId).toList(), userId);

      return dailyQuests;
    }
    return [];
  }

  @override
  Future<List<dynamic>> submitQuest(File imageFile, Map<String, dynamic> questData) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return [false, 0, "User tidak ditemukan"];
      }
      if (questData['quest_id'] == null || questData['target_count'] == null) {
        return [false, 0, "Data quest tidak valid"];
      }

      final answer = await _gemini.validateImage(
        imageFile,
        questData['trash'],
        questData['description'],
      );
      final answerParts = answer.split(",");
      var progress = await hunterService.getProgress(uid, questData['quest_id']);

      final isTrash = answerParts[0] == 'true';
      final trashCount = int.tryParse(answerParts[1]) ?? 0;

      if (isTrash) {
        progress = progress + trashCount;
      }

      final isCompleted = progress >= (questData['target_count'] as int);
      if (isCompleted) {
        progress = questData['target_count'];
      }

      await hunterService.updateProgress(uid, questData, progress, isCompleted);

      if (!isTrash) {
        final reason = answerParts.length > 2 ? answerParts[2] : "Gambar tidak sesuai misi";
        return [false, progress, reason];
      }

      return [isTrash, progress, null];
    } catch (e) {
      return [false, 0, "Terjadi kesalahan: ${e.toString()}"];
    }
  }
}