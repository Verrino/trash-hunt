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
          future: fetchTrashTypes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.green.shade700),
                    const SizedBox(height: 16),
                    Text("Memuat data sampah...", style: TextStyle(color: Colors.green.shade900)),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada data tersedia', style: TextStyle(color: Colors.green.shade900)));
            } else {
              trashList = snapshot.data!;
              return buildHomeScreen();
            }
          },
        ),
      ),
    );
  }

  Widget buildHomeScreen() {
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
                  child: Icon(Icons.eco, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Text(
                  "Jenis Sampah",
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
                Text("🌱", style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Kenali berbagai jenis sampah berikut untuk membantumu dalam misi Trash Hunt!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            // List Sampah
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trashList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final trash = trashList[index];
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.green.shade50,
                  shadowColor: Colors.green.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: TrashDetailCard(
                      type: trash['type'],
                      description: trash['description'],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "🌳 Ayo pilah dan kumpulkan sampah untuk bumi yang lebih hijau! 🌏",
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