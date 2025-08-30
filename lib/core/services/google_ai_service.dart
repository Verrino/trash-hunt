import 'dart:convert';
import 'dart:io';

import 'package:flutter_gemini/flutter_gemini.dart';

class GoogleAiService {
  final _gemini = Gemini.instance;

  Future<String> validateImage(File file, String trash, String description) async {
    final bytes = await file.readAsBytes();
    final String base64Image = base64Encode(bytes);
    // final models = await Gemini.instance.listModels();
    // for (var model in models ?? []) {
    //   print('Model: ${model.name}');
    // }
    try {
      final response = await _gemini.prompt(
        parts: [
          Part.text("""
          Berikan jawaban true atau false, dan banyak sampah.
          Jika jawaban false, berikan output 0 pada jumlah dan alasannya.
          Jika jawaban true, berikan output jumlah sampah yang ditemukan dan tidak perlu berikan alasan.
          Format jawaban dengan lowercase yaitu: <boolean>,<jumlah>,<alasan>.

          Deskripsi Sampah:
          $description

          Pertanyaan:
          Apakah gambar ini merupakan sampah $trash dan jika true berapa banyak?
          """),
          Part.inline(InlineData(mimeType: 'image/jpeg', data: base64Image)),
        ],
        model: "models/gemma-3-27b-it"
      );
      final answer = (response?.content?.parts?.first as TextPart).text;
      return answer.replaceAll('\n', '').trim();
    } catch (e) {
      print('Error: $e');
      return 'false,0';
    }
  }
}