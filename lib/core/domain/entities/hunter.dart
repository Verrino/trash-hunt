import 'package:cloud_firestore/cloud_firestore.dart';

class Hunter {
  final String userId;
  final String organizationId;
  final String username;
  final String profilePictureUrl;
  final DateTime birthDate;
  final int totalTrash;
  final int level;
  final int exp;
  final int coins;
  final List<String> friendIds;
  final List<Map<String, dynamic>> dailyQuests;
  final List<Map<String, dynamic>> completedQuests;
  final bool isQuestsCompleted;
  final bool isQuestsGiven;
  final DateTime questGivenAt;

  Hunter({
    required this.userId,
    this.organizationId = "",
    required this.username,
    this.profilePictureUrl = "",
    required this.birthDate,
    this.totalTrash = 0,
    this.level = 1,
    this.exp = 0,
    this.coins = 0,
    this.friendIds = const [],
    this.dailyQuests = const [],
    this.completedQuests = const [],
    this.isQuestsCompleted = false,
    this.isQuestsGiven = false,
    DateTime? questGivenAt,
  }) : questGivenAt = questGivenAt ?? DateTime.now().subtract(const Duration(days: 1));

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'organization_id': organizationId,
      'username': username,
      'profile_picture_url': profilePictureUrl,
      'birth_date': birthDate.toIso8601String(),
      'total_trash': totalTrash,
      'level': level,
      'exp': exp,
      'coins': coins,
      'friend_ids': friendIds,
      'daily_quests': dailyQuests,
      'completed_quests': completedQuests,
      'is_quests_completed': isQuestsCompleted,
      'is_quests_given': isQuestsGiven,
      'quest_given_at': questGivenAt.toIso8601String(),
    };
  }

  factory Hunter.fromJson(Map<String, dynamic> json) {
    if (json['birth_date'] is String) {
      json['birth_date'] = DateTime.parse(json['birth_date']);
    }
    else if (json['birth_date'] is Timestamp) {
      json['birth_date'] = (json['birth_date'] as Timestamp).toDate();
    }

    if (json['quest_given_at'] is String) {
      json['quest_given_at'] = DateTime.parse(json['quest_given_at']);
    }
    else if (json['quest_given_at'] is Timestamp) {
      json['quest_given_at'] = (json['quest_given_at'] as Timestamp).toDate();
    }

    return Hunter(
      userId: json['user_id'] as String,
      organizationId: json['organization_id'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profile_picture_url'] as String,
      birthDate: json['birth_date'] as DateTime,
      totalTrash: json['total_trash'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      exp: json['exp'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      friendIds: (json['friend_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      dailyQuests: (json['daily_quests'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
          [],
      completedQuests: (json['completed_quests'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
          [],
      isQuestsCompleted: json['is_quests_completed'] as bool? ?? false,
      isQuestsGiven: json['is_quests_given'] as bool? ?? false,
      questGivenAt: json['quest_given_at'] as DateTime? ?? DateTime.now().subtract(const Duration(days: 1)),
    );
  }
}