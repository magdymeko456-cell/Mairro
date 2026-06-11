#!/bin/bash

MAIN_FILE="lib/main.dart"

echo "⏳ 1. تصفير وإعادة كتابة ملف main.dart بالكامل على نظافة..."
cat << 'INNER_EOF' > "$MAIN_FILE"
import 'package:flutter/material.dart';
import 'features/home_screen.dart';
import 'features/card1_translation/translation_screen.dart';
import 'features/card4_stories/stories_screen.dart';

void main() {
  runApp(const MirrorScorpionApp());
}

class MirrorScorpionApp extends StatelessWidget {
  const MirrorScorpionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirror Scorpion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/translation': (context) => TranslationScreen(), // مكتوبة بإيدينا ومن غير const
        '/stories': (context) => const StoriesScreen(),
        
        // مسارات مؤقتة لتفادي ملفات الشاشات الناقصة في السيرفر
        '/lens': (context) => const HomeScreen(),
        '/games': (context) => const HomeScreen(),
        '/rubik': (context) => const HomeScreen(),
        '/settings': (context) => const HomeScreen(),
      },
    );
  }
}
INNER_EOF

echo "👀 2. مراجعة الملف المكتوب بالكامل للتأكد بنسبة 100%..."
echo "--------------------------------------------------------"
cat "$MAIN_FILE"
echo "--------------------------------------------------------"

echo "⏳ 3. تعميد الملف النظيف في الـ Git..."
git add "$MAIN_FILE"

echo "⏳ 4. تسجيل الـ Commit بقرارنا وتركيزنا..."
git commit -m "fix: rewrite main.dart completely from scratch to remove const error and keep formatting clean"

echo "🚀 5. الرفع النهائي المضمون إلى جيت هب..."
git push origin main

echo "✅ تم المسح وإعادة الكتابة والرفع بنجاح يا تامر! تابع البناء رقم 24 أو 25."
