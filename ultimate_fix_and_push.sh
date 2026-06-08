#!/bin/bash

echo "⏳ 1. إعادة كتابة ملف ai_service.dart النظيف تماماً بدون أي تعليقات جانبية..."
cat << 'INNER_EOF' > lib/services/ai_service.dart
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

  static Future<String> generateInspiration({String? userMood, String lang = "ar"}) async {
    try {
      if (lang == 'ar') {
        return "حيث تُصنع البدايات - ميرور سكوربيون";
      }
      return "Where beginnings are made - Mirror Scorpion";
    } catch (e) {
      debugPrint('Inspiration error: $e');
      return "Mirror Scorpion";
    }
  }
}
INNER_EOF

echo "⏳ 2. إصلاح دقيق لأقواس ملف main.dart المكسورة يدوياً..."
if [ -f "lib/main.dart" ]; then
  # استبدال السطر المكسور ليتضمن قفلة القوس والفاصلة بشكل برميجي دقيق ومغلق
  sed -i 's/.*\/rubik.*/    \x27\/rubik\x27: (context) => const RubikCubeScreen(),/g' lib/main.dart
fi

echo "⏳ 3. جاري تعميد وإضافة الملفات للـ Git..."
git add lib/services/ai_service.dart lib/main.dart

echo "⏳ 4. جاري عمل الـ Commit الصافي الصافي..."
git commit -m "fix: clean ai_service from hash comments and fix main.dart routes indentation"

echo "🚀 5. جاري الرفع المدمج التلقائي إلى جيت هب..."
git push origin main

echo "✅ تم التنظيف والرفع بنجاح يا تامر يا غالي! تابع البناء رقم 17 الآن."
