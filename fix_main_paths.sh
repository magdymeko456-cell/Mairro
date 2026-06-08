#!/bin/bash

echo "⏳ 1. إعادة كتابة main.dart بالاعتماد على الشاشات المرفوعة والموجودة فقط..."
cat << 'INNER_EOF' > lib/main.dart
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
        '/translation': (context) => const TranslationScreen(),
        '/stories': (context) => const StoriesScreen(),
        
        // المسارات التالية ممررة مؤقتاً للشاشة الرئيسية لأن ملفاتها غير مرفوعة بعد
        '/lens': (context) => const HomeScreen(),
        '/games': (context) => const HomeScreen(),
        '/rubik': (context) => const HomeScreen(),
        '/settings': (context) => const HomeScreen(),
      },
    );
  }
}
INNER_EOF

echo "⏳ 2. جاري إضافة ملف main.dart المضمون للـ Git..."
git add lib/main.dart

echo "⏳ 3. جاري عمل الـ Commit..."
git commit -m "fix: route only existing screens to bypass missing files compiler errors"

echo "🚀 4. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم تنظيف المسارات والرفع بنجاح يا تامر! تابع البناء رقم 20 الآن."
