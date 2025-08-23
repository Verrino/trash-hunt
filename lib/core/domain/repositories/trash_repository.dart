import 'package:trash_hunt/core/domain/entities/trash.dart';

abstract class TrashRepository {
  Future<List<Trash>> getTrashTypes();
}