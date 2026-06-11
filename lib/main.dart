import 'package:flutter/material.dart';  
import 'package:flutter/services.dart';  
import 'package:provider/provider.dart';  
import 'package:flutter_localizations/flutter_localizations.dart';  
import 'features/home_screen.dart';  
import 'features/card1_translation/translation_screen.dart';  
import 'features/card2_dialogue/dialogue_screen.dart';  
import 'features/card3_document/document_screen.dart';  
import 'features/card4_stories/stories_screen.dart';  
import 'features/settings/settings_screen.dart';  
import 'features/games/chess/chess_screen.dart';  
import 'features/games/rubik_cube/rubik_cube_screen.dart';  
import 'services/floating_bubble_service.dart';  
import 'services/premium_verification_service.dart';  
import 'services/tts_service.dart';  
import 'core/theme/theme_provider.dart';  
  
void main() async {  
  WidgetsFlutterBinding.ensureInitialized();  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  
  
  final bubbleService = FloatingBubbleService();  
  await bubbleService.initialize();  
  
  final premiumService = PremiumVerificationService();  
  await premiumService.initialize();  
  
  runApp(  
    MultiProvider(  
      providers: [  
        ChangeNotifierProvider.value(value: bubbleService),  
        ChangeNotifierProvider.value(value: premiumService),  
        ChangeNotifierProvider(create: (_) => TTSService()),  
        ChangeNotifierProvider(create: (_) => ThemeProvider()),  
      ],  
      child: const MirrorScorpionApp(),  
    ),  
  );  
}  
  
class MirrorScorpionApp extends StatelessWidget {  
  const MirrorScorpionApp({super.key});  
  
  @override  
  Widget build(BuildContext context) {  
    final themeProvider = Provider.of<ThemeProvider>(context);  
    final deviceLocale =  
        WidgetsBinding.instance.platformDispatcher.locale;  
    final locale = deviceLocale.languageCode == 'ar'  
        ? const Locale('ar')  
        : const Locale('en');  
  
    return MaterialApp(  
      title: 'ميرور سكربيون',  
      debugShowCheckedModeBanner: false,  
      localizationsDelegates: const [  
        GlobalMaterialLocalizations.delegate,  
        GlobalWidgetsLocalizations.delegate,  
        GlobalCupertinoLocalizations.delegate,  
      ],  
      supportedLocales: const [Locale('ar'), Locale('en')],  
      locale: locale,  
      theme: themeProvider.themeData,  
      initialRoute: '/',  
      routes: {  
        '/': (context) => const HomeScreen(),  
        '/translate': (context) => const TranslationScreen(),  
        '/dialogue': (context) => const DialogueScreen(),  
        '/document': (context) => const DocumentScreen(),  
        '/stories': (context) => const StoriesScreen(),  
        '/settings': (context) => const SettingsScreen(),  
        '/rubik': (context) => const RubikCubeScreen(),  
        '/chess': (context) => const ChessScreen(),  
      },  
    );  
  }  
}  
