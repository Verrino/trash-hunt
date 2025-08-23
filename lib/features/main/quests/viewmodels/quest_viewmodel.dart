import 'package:flutter/material.dart';
import 'package:trash_hunt/core/domain/entities/trash.dart';
import 'package:trash_hunt/features/main/services/trash_repository_impl.dart';

class QuestViewModel extends ChangeNotifier {
  final TrashRepositoryImpl _trashService;
  QuestViewModel(this._trashService);

  Future<List<Map<String, dynamic>>> getTrash() async {
    final List<Trash> trash = await _trashService.getTrashTypes();
    return trash.map((e) => e.toMap()).toList();
  }
}