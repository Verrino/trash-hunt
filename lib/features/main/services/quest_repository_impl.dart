import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash_hunt/core/domain/entities/quest.dart';
import 'package:trash_hunt/core/domain/repositories/quest_repository.dart';
import 'package:trash_hunt/features/main/services/hunter_repository_impl.dart';

class QuestRepositoryImpl extends QuestRepository {
  final _firestore = FirebaseFirestore.instance;
  final HunterRepositoryImpl hunterService = HunterRepositoryImpl();

  @override
  Future<List<Quest>> getDailyQuests() async {
    final ref = await _firestore.collection('quests').get();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (ref != null) {
      List<Quest> allDailyQuests = ref.docs
          .where((doc) => doc.data()['quest_type'] == 'daily')
          .map((doc) => Quest.fromJson(doc.data(), doc.id))
          .toList();

      List<Quest> dailyQuests = [];
      if (await hunterService.hasAssignedQuests(userId!)) {
        print("Sudah ada quest");
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

        // Assign daily quests id to Hunter
        await hunterService.assignQuestsToHunter(dailyQuests.map((e) => e.questId).toList(), userId);

        return dailyQuests;
      }
    }
    return [];
  }
}