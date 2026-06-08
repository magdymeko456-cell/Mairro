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
