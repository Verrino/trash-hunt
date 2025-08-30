import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/features/main/quests/viewmodels/quest_detail_viewmodel.dart';

class QuestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> questData;

  const QuestDetailScreen({super.key, required this.questData});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> with SingleTickerProviderStateMixin {
  String? _capturedImagePath;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = widget.questData['progress'] ?? 0;
      context.read<QuestDetailViewModel>().set(progress: progress);
    });
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestDetailViewModel>();
    final int progress = vm.progress;
    final int target = widget.questData['target_count'] ?? 1;
    final bool isDone = progress >= target;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700.withValues(alpha: 0.9),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.flag, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Detail Misi Harian',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB7F8DB),
                  Color(0xFF50A7C2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  48 + MediaQuery.of(context).padding.top + kToolbarHeight,
                  24,
                  48,
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    color: Colors.green.shade50,
                    shadowColor: Colors.green.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon dan judul
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.green.shade700,
                            child: Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            widget.questData['title'],
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                              letterSpacing: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.green.shade200,
                                  blurRadius: 4,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Divider(
                            color: Colors.green.shade200,
                            thickness: 1.2,
                          ),
                          const SizedBox(height: 10),
                          // Deskripsi
                          Text(
                            widget.questData['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green.shade900,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.orange.shade400, size: 22),
                              const SizedBox(width: 4),
                              Text(
                                'XP: ${widget.questData['exp_reward']}',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 22),
                              const SizedBox(width: 4),
                              Text(
                                'Coins: ${widget.questData['coins_reward']}',
                                style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.terrain, color: Colors.green.shade400, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                "Kesulitan: ${widget.questData['quest_difficulty']}",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (progress / target).clamp(0.0, 1.0),
                              minHeight: 10,
                              backgroundColor: Colors.green.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Progress: $progress / $target",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green.shade800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Gambar atau tombol kamera
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _capturedImagePath == null
                                ? GestureDetector(
                                    key: const ValueKey('camera'),
                                    onTap: () async {
                                      final imagePath = await Navigator.pushNamed(context, AppRouter.camera);
                                      if (imagePath != null) {
                                        setState(() {
                                          _capturedImagePath = imagePath as String;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 220,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        border: Border.all(color: Colors.green.shade300, width: 2),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Icon(Icons.camera_alt, color: Colors.green.shade700, size: 60),
                                    ),
                                  )
                                : ClipRRect(
                                    key: const ValueKey('image'),
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.file(
                                      File(_capturedImagePath!),
                                      width: 220,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 18),
                          if (vm.reasonMessage != null) ...[
                            Text(
                              vm.reasonMessage!,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12)
                          ],
                          // Tombol submit
                          if (!vm.isLoading)
                            AnimatedScale(
                              scale: !isDone ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 400),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                                icon: const Icon(Icons.send),
                                label: const Text(
                                  'Kumpul Misi',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (_capturedImagePath == null) {
                                    vm.set(reason: "Silakan ambil gambar terlebih dahulu");
                                    return;
                                  }
                                  final success = await vm.submitQuest(File(_capturedImagePath!), widget.questData);
                                  setState(() {
                                    _capturedImagePath = null;
                                  });
                                  if (!context.mounted) return;
                                  if (success && Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          if (isDone)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Misi selesai! 🎉",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (vm.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
