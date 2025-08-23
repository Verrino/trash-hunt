import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/features/main/home/viewmodels/home_viewmodel.dart';
import 'package:trash_hunt/widgets/trash_detail_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> trashList;

  Future<List<Map<String, dynamic>>> fetchTrashTypes() async {
    final vm = context.read<HomeViewModel>();
    return await vm.getTrash();
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
            trashList = snapshot.data!;
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
          Text("Deskripsi Sampah"),
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
            itemCount: trashList.length,
            itemBuilder: (context, index) {
              final trash = trashList[index];
              return TrashDetailCard(type: trash['type'], description: trash['description']);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}