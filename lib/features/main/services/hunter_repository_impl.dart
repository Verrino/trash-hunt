import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
import 'package:trash_hunt/core/domain/repositories/hunter_repository.dart';

class HunterRepositoryImpl extends HunterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addHunter(
    String userId,
    String username,
    DateTime birthDate,
    int totalTrash,
    int level,
    int exp,
    int coins,
    List<String> friendIds,
  ) async {
    final Hunter hunter = Hunter(
      userId: userId,
      username: username,
      birthDate: birthDate,
      totalTrash: totalTrash,
      level: level,
      exp: exp,
      coins: coins,
      friendIds: friendIds,
    );

    return await _firestore.collection('hunters').doc(userId).set(hunter.toJson());
  }

  @override
  Future<void> updateHunter(
    String userId,
    String username,
    DateTime birthDate,
    int totalTrash,
    int level,
    int exp,
    int coins,
    List<String> friendIds,
  ) async {
    final Hunter hunter = Hunter(
      userId: userId,
      username: username,
      birthDate: birthDate,
      totalTrash: totalTrash,
      level: level,
      exp: exp,
      coins: coins,
      friendIds: friendIds,
    );

    return await _firestore.collection('hunters').doc(userId).update(hunter.toJson());
  }

}