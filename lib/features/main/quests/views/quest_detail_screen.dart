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

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestDetailViewModel>().set(null);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestDetailViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questData['title']),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Deskripsi Misi"),
                        Text(widget.questData['description']),
                        const SizedBox(height: 8),
                        Text("Tingkat Kesulitan: ${widget.questData['quest_difficulty']}"),
                        const SizedBox(height: 8),
                        Text("Progress: ${vm.progress}/${widget.questData['target_count']}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final imagePath = await Navigator.pushNamed(context, AppRouter.camera);
          
                      if (imagePath != null) {
                        setState(() {
                          _capturedImagePath = imagePath as String;
                        });
                      }
                    },
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _capturedImagePath == null
                        ? Icon(Icons.camera_alt)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_capturedImagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (vm.reasonMessage != null) ... [
                    Text(
                      vm.reasonMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16)
                  ],
                  if (!vm.isLoading)
                    InkWell(
                      onTap: () async {
                        if (_capturedImagePath == null) {
                          vm.set("Please capture an image");
                          return;
                        }
                        final success = await vm.submitQuest(File(_capturedImagePath!), widget.questData);
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Kumpul Misi'),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (vm.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}