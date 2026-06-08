import 'package:flutter/material.dart';
import 'features/home_screen.dart';
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
        '/stories': (context) => const StoriesScreen(),
        
        // تمرير الشاشات غير المرفوعة أو الناقصة مؤقتاً للشاشة الرئيسية لتفادي أخطاء الكومبايلر
        '/translation': (context) => const HomeScreen(),
        '/lens': (context) => const HomeScreen(),
        '/games': (context) => const HomeScreen(),
        '/rubik': (context) => const HomeScreen(),
        '/settings': (context) => const HomeScreen(),
      },
    );
  }
}
