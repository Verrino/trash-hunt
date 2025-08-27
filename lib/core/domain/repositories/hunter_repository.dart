import 'package:trash_hunt/core/domain/entities/hunter.dart';

abstract class HunterRepository {
  Future<bool> addHunter(
    String userId, 
    String username, 
    DateTime birthDate
  );

  Future<void> updateHunter({
    required String userId, 
    String? username, 
    DateTime? birthDate, 
    int? totalTrash, 
    int? level, 
    int? exp, 
    int? coins, 
    List<String>? friendIds,
  });

  Future<void> applyProgress({
    required String userId,
    int totalTrashDelta,
    int expDelta,
    int coinsDelta,
  });

  Future<Hunter?> getHunter(String uid);
  Future<void> assignQuestsToHunter(List<String> questIds, String uid);
  Future<bool> hasAssignedQuests(String uid);
  Future<List<Map<String, dynamic>>> getAssignedQuests(String uid);
  Future<void> resetDailyQuests(String uid);
  Future<void> completeDailyQuest(String uid, String questId);
}