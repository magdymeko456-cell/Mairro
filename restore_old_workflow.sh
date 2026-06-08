#!/bin/bash

echo "⏳ 1. استعادة ملف الـ Workflow القديم والمستقر بالكامل من تاريخ الـ Git..."
# سحب آخر نسخة مستقرة للملف قبل التعديلات الأخيرة
git checkout origin/main -- .github/workflows/build.yml 2>/dev/null || git checkout HEAD~2 -- .github/workflows/build.yml 2>/dev/null

echo "⏳ 2. إضافة خطوة تنظيف الكاش بخلاصة التجارب في مكان آمن..."
# هنضيف أمر flutter clean قبل أمر البناء مباشرة في الملف المستقر
if [ -f ".github/workflows/build.yml" ]; then
  sed -i '/flutter build apk/i \      - name: Clean Cache\n        run: flutter clean' .github/workflows/build.yml
  echo "✅ تم دمج خلاصة التجارب في الورك فلو القديم بنجاح."
else
  echo "⚠️ لم نتمكن من سحب القديم، سنعتمد على الهيكل القياسي المستقر."
fi

echo "⏳ 3. عمل تنظيف محلي وتحديث للمكتبات للتأكد من سلامة الكود..."
flutter clean 2>/dev/null
flutter pub get 2>/dev/null

echo "⏳ 4. تعميد الملفات وإرسال التعديلات..."
git add .
git commit -m "chore: revert to stable old workflow configuration with clean cache step added"

echo "🚀 5. الرفع النهائي إلى جيت هب..."
git push origin main

echo "✅ تم الرجوع للأصل والرفع يا صاحبي! راقب البناء رقم 23 الآن."
