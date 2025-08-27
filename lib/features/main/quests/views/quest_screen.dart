import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/features/main/quests/viewmodels/quest_viewmodel.dart';
import 'package:trash_hunt/widgets/quest_card.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  late List<Map<String, dynamic>> dailyQuestList;

  Future<List<Map<String, dynamic>>> fetchTrashTypes() async {
    final vm = context.read<QuestViewModel>();
    return await vm.getDailyQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTrashTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            dailyQuestList = snapshot.data!;
            return buildHomeScreen();
          }
        },
      ),
    );
  }

  Widget buildHomeScreen() {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Daily Quests"),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 1,
            ),
            itemCount: dailyQuestList.length,
            itemBuilder: (context, index) {
              final quest = dailyQuestList[index];
              return QuestCard(
                questData: quest,
              );
            },
          ),
        ],
      ),
    );
  }
}
