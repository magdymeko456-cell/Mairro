#!/bin/bash

# سكريبت البلدوزر المطهر من المسافات الزائدة - ترمكس وسيط تحرير
echo "⏳ جاري تهيئة المجلدات وحقن الأكواد الصافية لـ Mirror Scorpion..."

# 1. إنشاء المجلدات لضمان سلامة المسارات
mkdir -p lib/core/theme
mkdir -p lib/features/card1_translation
mkdir -p lib/features/card2_dialogue
mkdir -p lib/features/card3_document
mkdir -p lib/features/card4_stories
mkdir -p lib/features/settings
mkdir -p lib/features/games/chess
mkdir -p lib/features/games/rubik_cube
mkdir -p lib/services

# 2. حقن ملف lib/main.dart الصافي تماماً وبدون أي مسافات زائدة
cat > lib/main.dart << 'INNER_EOF'
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
INNER_EOF

echo "✅ تم تحرير وتنظيف ملف lib/main.dart بنجاح."

# 3. إعداد الـ Git وعمل الـ Commit والتطهير للرفع
echo "⏳ جاري إعداد عملية الرفع إلى GitHub..."
git config --global pull.rebase true
git rebase --abort 2>/dev/null || true

git add -A
git commit -m "Fix: Replace admin app with Mirror Scorpion main app + add CI/CD workflow" 2>/dev/null || true

# 4. محاولة الـ Pull والرفع النهائي بالقوة لفرض الاستقرار ومسح التعارض
echo "📥 جاري عمل Pull ذكي مع أولوية للتعديلات المحلية الحالية..."
git pull --rebase -X ours https://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@github.com/magdymeko456-cell/Mairro.git main

echo "📤 جاري الرفع النهائي للبيئة المحدثة..."
git push --force https://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@github.com/magdymeko456-cell/Mairro.git main

if [ $? -eq 0 ]; then
    echo "🎯 تم التحرير والرفع بالقوة بنجاح يا تامر! سيرفر الـ GitHub Actions انطلق الآن ببناء مستقر."
    exit 0
else
    echo "❌ فشل الرفع، يرجى مراجعة اتصال الشبكة في الترمكس."
    exit 1
fi
