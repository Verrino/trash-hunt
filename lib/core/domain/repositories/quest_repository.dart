import 'package:trash_hunt/core/domain/entities/quest.dart';

abstract class QuestRepository {
  Future<List<Quest>> getDailyQuests();
}