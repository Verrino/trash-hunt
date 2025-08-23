class Hunter {
  final String userId;
  final String username;
  final DateTime birthDate;
  final int totalTrash;
  final int level;
  final int exp;
  final int coins;
  final List<String> friendIds;

  Hunter({
    required this.userId,
    required this.username,
    required this.birthDate,
    this.totalTrash = 0,
    this.level = 1,
    this.exp = 0,
    this.coins = 0,
    this.friendIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'birthDate': birthDate.toIso8601String(),
      'totalTrash': totalTrash,
      'level': level,
      'exp': exp,
      'coins': coins,
      'friendIds': friendIds,
    };
  }

  factory Hunter.fromJson(Map<String, dynamic> json) {
    return Hunter(
      userId: json['userId'] as String,
      username: json['username'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      totalTrash: json['totalTrash'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      exp: json['exp'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      friendIds: (json['friendIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }
}