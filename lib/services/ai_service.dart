import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final String _apiKey = "YOUR_GEMINI_API_KEY";

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final url = Uri.parse('https://translation.api.mock/translate');
      final response = await http.post(url, body: {'text': text, 'lang': targetLanguage});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['translatedText'] ?? text;
      }
      return text;
    } catch (e) {
      debugPrint('Translation error: $e');
      return text;
    }
  }
}
