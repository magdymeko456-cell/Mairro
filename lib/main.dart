import 'package:flutter/material.dart';
import 'features/home_screen.dart';
import 'features/card1_translation/translation_screen.dart';
import 'features/card2_lens/lens_screen.dart';
import 'features/card3_games/games_screen.dart';
import 'features/card3_games/rubik/rubik_cube_screen.dart';
import 'features/card4_stories/stories_screen.dart';
import 'features/card5_settings/settings_screen.dart';

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
        '/lens': (context) => const LensScreen(),
        '/games': (context) => const GamesScreen(),
        '/rubik': (context) => const RubikCubeScreen(),
        '/stories': (context) => const StoriesScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
