import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class QuestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> questData;

  const QuestDetailScreen({super.key, required this.questData});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeCamera().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> initializeCamera() async {
    try {
      var cameras = await availableCameras();
      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questData['title']),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CameraPreview(_controller),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        print("Image captured: ${image.path}");
                      } catch (e) {
                        print("Error capturing image: $e");
                      }
                    },
                    child: Text("Capture Image"),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}