import 'dart:io';

import 'package:trash_hunt/core/domain/entities/quest.dart';

abstract class QuestRepository {
  Future<List<Quest>> getDailyQuests();
  Future<List<dynamic>> submitQuest(File imageFile, Map<String, dynamic> questData);
}