import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash_hunt/core/domain/entities/trash.dart';
import 'package:trash_hunt/core/domain/repositories/trash_repository.dart';

class TrashRepositoryImpl extends TrashRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<List<Trash>> getTrashTypes() async {
    List<Trash>? trash;

    try {
      final snapshot = await _fireStore.collection('trash').get();
      trash = snapshot.docs.map((doc) => Trash.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      // Handle error
    }

    return trash ?? [];
  }
}