abstract class HunterRepository {
  Future<void> addHunter(
    String userId, 
    String username, 
    DateTime birthDate, 
    int totalTrash, 
    int level, 
    int exp, 
    int coins, 
    List<String> friendIds
  );

  Future<void> updateHunter(
    String userId, 
    String username, 
    DateTime birthDate, 
    int totalTrash, 
    int level, 
    int exp, 
    int coins, 
    List<String> friendIds
  );
}