import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LevelConfig {
  static int maxLevel = 1;
  static List<int> expCurve = [];

  static Future<void> load() async {
    final jsonStr = await rootBundle.loadString('assets/config/leveling.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    maxLevel = data['max_level'] as int;
    expCurve = (data['exp_curve'] as List<dynamic>).map((e) => e as int).toList();
  }

  static int expToNext(int level) {
    if (level <= 0) return expCurve.first;
    if (level > expCurve.length) {
      return expCurve.last;
    }
    return expCurve[level - 1]; 
  }
}
