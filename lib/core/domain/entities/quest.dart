class Quest {
  final String questId;
  final String questType;
  final String questDifficulty;
  final String title;
  final String trash;
  final String description;
  final int targetCount;
  final int expReward;
  final int coinsReward;

  Quest({
    required this.questId,
    required this.questType,
    required this.questDifficulty,
    required this.title,
    required this.trash,
    required this.description,
    required this.targetCount,
    required this.expReward,
    required this.coinsReward,
  });

  factory Quest.fromJson(Map<String, dynamic> json, String questId) {
    return Quest(
      questId: questId,
      questType: json['quest_type'],
      questDifficulty: json['quest_difficulty'],
      title: json['title'],
      trash: json['trash'],
      description: json['description'],
      targetCount: json['target_count'],
      expReward: json['exp_reward'],
      coinsReward: json['coins_reward'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quest_id': questId,
      'quest_type': questType,
      'quest_difficulty': questDifficulty,
      'title': title,
      'trash': trash,
      'description': description,
      'target_count': targetCount,
      'exp_reward': expReward,
      'coins_reward': coinsReward,
    };
  }
}