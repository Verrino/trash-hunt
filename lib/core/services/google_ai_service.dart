import 'package:camera/camera.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GoogleAiService {
  final gemini = Gemini.instance;

  Future<bool> validateImage(XFile file, String sampah) async {
    gemini.prompt(
      parts: [
        Part.text("""
        Berikan jawaban true atau false.

        Apakah gambar ini merupakan sampah $sampah?
        """),
        Part.file(FileDataPart(fileUri: file.path, mimeType: 'image/jpeg')),
      ],
      model: "models/gemma-3-27b-it"
    );
    return true;
  }
}