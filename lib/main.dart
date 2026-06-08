import 'package:flutter/material.dart';
import 'features/home_screen.dart';
import 'features/card4_stories/stories_screen.dart';

void main() {
  // تأمين بيئة عمل فلاتر قبل تشغيل الـ runApp لضمان استقرار الخدمات الخلفية
  WidgetsFlutterBinding.ensureInitialized();
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
        
        // مطابقة وتأمين كافة مسارات الكروت لتفادي أخطاء الـ Navigation الصامتة
        '/translate': (context) => const HomeScreen(),
        '/dialogue': (context) => const HomeScreen(),
        '/document': (context) => const HomeScreen(),
        '/chess': (context) => const HomeScreen(),
        '/rubik': (context) => const HomeScreen(),
        '/settings': (context) => const HomeScreen(),
      },
    );
  }
}
