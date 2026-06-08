import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home_screen.dart';
import 'features/card4_stories/stories_screen.dart';
import 'services/language_service.dart';
import 'services/floating_bubble_service.dart';

void main() async {
  // تأمين بيئة عمل فلاتر
  WidgetsFlutterBinding.ensureInitialized();
  
  // إنشاء النسخ وتأمين عملية الـ Initialize قبل إقلاع التطبيق
  final languageService = LanguageService();
  await languageService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageService>.value(value: languageService),
        ChangeNotifierProvider(create: (_) => FloatingBubbleService()),
      ],
      child: const MirrorScorpionApp(),
    ),
  );
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
        
        // مسارات معتمدة ومؤمنة مؤقتاً لتفادي أخطاء الـ Router
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
