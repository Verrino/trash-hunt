import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash_hunt/core/config/level_config.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
import 'package:trash_hunt/core/domain/repositories/hunter_repository.dart';
import 'package:trash_hunt/core/services/server_timestamp.dart';

class HunterRepositoryImpl extends HunterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> addHunter(
    String userId,
    String username,
    DateTime birthDate
  ) async {
    final Hunter hunter = Hunter(
      userId: userId,
      username: username,
      birthDate: birthDate,
    );
    try {
      await _firestore.collection('hunters').doc(userId).set(hunter.toJson());
      return true;
    }
    catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateHunter({
    required String userId,
    String? username,
    DateTime? birthDate,
    int? totalTrash,
    int? level,
    int? exp,
    int? coins,
    List<String>? friendIds,
  }) async {
    final updates = <String, dynamic>{
      if (username != null) 'username': username,
      if (birthDate != null) 'birth_date': Timestamp.fromDate(birthDate),
      if (totalTrash != null) 'total_trash': totalTrash,
      if (level != null) 'level': level,
      if (exp != null) 'exp': exp,
      if (coins != null) 'coins': coins,
      if (friendIds != null) 'friend_ids': friendIds,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (updates.length == 1) return;

    await _firestore
        .collection('hunters')
        .doc(userId)
        .set(updates, SetOptions(merge: true));
  }

  @override
  Future<void> applyProgress({
    required String userId,
    int totalTrashDelta = 0,
    int expDelta = 0,
    int coinsDelta = 0,
  }) async {
    final ref = _firestore.collection('hunters').doc(userId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);

      if (!snap.exists) return;

      final d = snap.data()!;
      final oldTrash = (d['total_trash'] ?? 0) as int;
      final oldExp   = (d['exp'] ?? 0) as int;
      final oldLevel = (d['level'] ?? 1) as int;
      final oldCoins = (d['coins'] ?? 0) as int;

      var newTrash = max(0, oldTrash + (totalTrashDelta));
      var expAcc = max(0, oldExp + (expDelta));
      var level = max(1, oldLevel);
      var newCoins = max(0, oldCoins + (coinsDelta));

      final maxLevel = LevelConfig.maxLevel > 0 ? LevelConfig.maxLevel : 100;

      if (level < maxLevel) {
        var levelUps = 0;
        while (level < maxLevel) {
          final need = expToNext(level);
          if (expAcc < need) break;
          expAcc -= need;
          level++;
          levelUps++;
        }

        // Bonus coins per level up (opsional)
        const bonusPerLevel = 10;
        newCoins += (levelUps * bonusPerLevel);
      }

      tx.update(ref, {
        'total_trash': newTrash,
        'exp': expAcc,
        'level': level,
        'coins': newCoins,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<Hunter?> getHunter(String uid, {bool forceRefresh = false}) async {
    var doc = await _firestore.collection('hunters').doc(uid).get(
      forceRefresh ? const GetOptions(source: Source.server) : null
    );
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return Hunter.fromJson(data);
  }

  @override
  Future<void> assignQuestsToHunter(List<String> questIds, String uid) async {
    final hunter = await getHunter(uid);
    if (hunter == null) return;

    List<Map<String, dynamic>> dailyQuests = questIds.map((id) {
      return {
        'quest_id': id,
        'progress': 0,
        'is_done': false,
      };
    }).toList();

    await _firestore.collection('hunters').doc(uid).update({
      'quest_given_at': FieldValue.serverTimestamp(),
      'is_quests_given': true,
      'daily_quests': dailyQuests,
    });
  }

  @override
  Future<bool> hasAssignedQuests(String uid) async {
    final hunter = await getHunter(uid);
    if (hunter == null) return false;

    return hunter.isQuestsGiven;
  }

  @override
  Future<List<Map<String, dynamic>>> getAssignedQuests(String uid) async {
    final hunter = await getHunter(uid);
    if (hunter == null) return [];

    return hunter.dailyQuests;
  }

  @override
  Future<void> resetDailyQuests(String uid) async {
    final now = await ServerTimestamp.now;
    final questGivenAt = await getQuestGivenAt(uid);

    final nowDate = DateTime(now.year, now.month, now.day);
    final questGivenDate = DateTime(questGivenAt.year, questGivenAt.month, questGivenAt.day);

    print("Current Date: $nowDate, Quest Given Date: $questGivenDate, Beda: ${nowDate.isAfter(questGivenDate)}");

    if (nowDate.isAfter(questGivenDate)) {
      await _firestore.collection('hunters').doc(uid).update({
        'daily_quests': [],
        'is_quests_given': false,
        'is_quests_completed': false,
      });
    }
  }

  Future<DateTime> getQuestGivenAt(String uid) async {
    final hunter = await getHunter(uid);
    if (hunter == null) {
      return (await ServerTimestamp.now).subtract(const Duration(days: 1));
    }

    return hunter.questGivenAt;
  }

  Future<int> getProgress(String uid, String questId) async {
    final hunter = await getHunter(uid);
    if (hunter == null) return 0;

    final quest = hunter.dailyQuests.firstWhere((q) => q['quest_id'] == questId);
    if (quest == null) return 0;

    return quest['progress'] ?? 0;
  }

  Future<void> updateProgress(String uid, Map<String, dynamic> questData, int newProgress, bool isDone) async {
    final hunter = await getHunter(uid);
    if (hunter == null) return;

    final quest = hunter.dailyQuests.cast<Map<String, dynamic>>().firstWhere(
      (q) => q['quest_id'] == questData['quest_id'],
      orElse: () => <String, dynamic>{},
    );

    final prevProgress = quest.isNotEmpty ? (quest['progress'] ?? 0) as int : 0;
    final prevIsDone = quest.isNotEmpty ? (quest['is_done'] ?? false) as bool : false;

    final progressDelta = (newProgress - prevProgress).clamp(0, questData['target_count'] ?? 1);

    if (progressDelta > 0) {
      await applyProgress(userId: uid, totalTrashDelta: progressDelta.toInt());
    }

    if (isDone && !prevIsDone) {
      await applyProgress(
        userId: uid,
        coinsDelta: questData['coins_reward'],
        expDelta: questData['exp_reward'],
      );
      final serverTime = await ServerTimestamp.now;
      await _firestore.collection('hunters').doc(uid).update({
        'completed_quests': FieldValue.arrayUnion([{
          'quest_id': questData['quest_id'],
          'completed_at': serverTime,
        }]),
      });
    }

    final quests = hunter.dailyQuests.map((q) {
      if (q['quest_id'] == questData['quest_id']) {
        return {
          'quest_id': questData['quest_id'],
          'progress': newProgress,
          'is_done': isDone,
        };
      }
      return q;
    }).toList();

    await _firestore.collection('hunters').doc(uid).update({
      'daily_quests': quests,
    });
  }

  @override
  Future<void> completeDailyQuest(String uid, String questId) async {

  }

  int expToNext(int level) {
    try {
      return LevelConfig.expToNext(level);
    } catch (_) {
      return 10000;
    }
  }
}