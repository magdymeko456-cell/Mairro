#!/bin/bash

echo "⏳ 1. تعديل إصدار التوزيعة لنسخة Gradle مستقرة وكاش في السيرفرات..."
FILE="android/gradle/wrapper/gradle-wrapper.properties"
if [ -f "$FILE" ]; then
  sed -i 's/gradle-9.1.0-all.zip/gradle-8.10.2-all.zip/g' "$FILE"
  echo "✅ تم تعديل الإصدار بنجاح."
else
  echo "❌ الملف غير موجود في هذا المسار، سنتخطى التعديل ونرفع مباشرة."
fi

echo "⏳ 2. عمل Commit سريع..."
git add android/gradle/wrapper/gradle-wrapper.properties 2>/dev/null
git commit -m "fix: downgrade gradle wrapper version to cached stable release to avoid 504 timeout" 2>/dev/null

echo "🚀 3. الرفع إلى جيت هب..."
git push origin main

echo "✅ تم الرفع! تابع البناء رقم 21 دلوقتي يا صاحبي."
