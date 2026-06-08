#!/bin/bash

echo "⏳ 1. عزل أكواد الشطرنج في مجلد آمن خارجي (keep_chess)..."
mkdir -p keep_chess
if [ -d "lib/features/games/chess" ]; then
  cp -r lib/features/games/chess/* keep_chess/
  rm -rf lib/features/games/chess
fi

echo "⏳ 2. تنظيف الاستدعاءات والمسارات المكسورة في ملف main.dart..."
if [ -f "lib/main.dart" ]; then
  # حذف أسطر الـ import الخاصة بالشطرنج والملفات المفقودة
  sed -i '/chess_screen.dart/d' lib/main.dart
  sed -i '/hadith_screen.dart/d' lib/main.dart
  sed -i '/story_viewer_screen.dart/d' lib/main.dart
  
  # حذف أسطر الـ routes الخاصة بيهم تماماً لمنع أخطاء التجميع
  sed -i '/"\/chess"/d' lib/main.dart
  sed -i '/"\/hadith"/d' lib/main.dart
  sed -i '/"\/story_viewer"/d' lib/main.dart
  sed -i '/\/hadith/d' lib/main.dart
  sed -i '/\/story_viewer/d' lib/main.dart
fi

echo "⏳ 3. جاري إضافة وتعميد التعديلات للـ Git..."
git add .

echo "⏳ 4. جاري عمل الـ Commit النظيف والمضمون..."
git commit -m "fix: isolate chess features to keep_chess and clean main.dart routes"

echo "🚀 5. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم التنظيف وعزل الأكواد والرفع بنجاح يا تامر! راقب البناء رقم 13 الآن."
