import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/features/main/quests/viewmodels/quest_viewmodel.dart';
import 'package:trash_hunt/widgets/quest_card.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> dailyQuestList;
  late Future<List<Map<String, dynamic>>> _futureQuests;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _futureQuests = fetchTrashTypes();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void refreshQuests() {
    setState(() {
      _futureQuests = fetchTrashTypes();
      _animController.reset();
    });
  }

  Future<List<Map<String, dynamic>>> fetchTrashTypes() async {
    final vm = context.read<QuestViewModel>();
    return await vm.getDailyQuests();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB7F8DB), // soft green
              Color(0xFF50A7C2), // soft blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureQuests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.green.shade700),
                    const SizedBox(height: 16),
                    Text("Memuat misi harian...", style: TextStyle(color: Colors.green.shade900)),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada misi tersedia', style: TextStyle(color: Colors.green.shade900)));
            } else {
              dailyQuestList = snapshot.data!;
              _animController.forward(from: 0); // start animation
              return buildQuestScreen(scheme);
            }
          },
        ),
      ),
    );
  }

  Widget buildQuestScreen(ColorScheme scheme) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade700,
                  radius: 30,
                  child: Icon(Icons.flag, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Text(
                  "Misi Harian",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.green.shade200,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text("🌿", style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Selesaikan misi berikut untuk mendapatkan XP dan koin, serta bantu bumi jadi lebih hijau!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dailyQuestList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final quest = dailyQuestList[index];
                final animation = Tween<Offset>(
                  begin: Offset(0, 0.2 + index * 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animController,
                  curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
                ));
                final fadeAnim = CurvedAnimation(
                  parent: _animController,
                  curve: Interval(0.1 * index, 1.0, curve: Curves.easeIn),
                );
                return SlideTransition(
                  position: animation,
                  child: FadeTransition(
                    opacity: fadeAnim,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.green.shade50,
                      shadowColor: Colors.green.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: QuestCard(
                          questData: quest,
                          onQuestCompleted: refreshQuests,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "🌱 Raih XP, kumpulkan koin, dan jadilah pahlawan lingkungan setiap hari! 🌏",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.green.shade100,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}