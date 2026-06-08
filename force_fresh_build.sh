#!/bin/bash

WORKFLOW_FILE=".github/workflows/build.yml"

echo "⏳ 1. فحص وتعديل ملف الـ Workflow لإضافة أمر التنظيف..."
if [ -f "$WORKFLOW_FILE" ]; then
  # إضافة خطوة flutter clean قبل بناء الـ APK لإجبار السيرفر على مسح الكاش
  sed -i '/flutter build apk/i \      - name: Clean Flutter Cache\n        run: flutter clean' "$WORKFLOW_FILE"
  echo "✅ تم تحديث ملف الـ Workflow بنجاح يا صاحبي."
else
  # إذا كان المسار مختلفاً قليلاً، سنبحث عنه في الفولدر
  WORKFLOW_FILE=$(find .github/workflows/ -name "*.yml" -o -name "*.yaml" | head -n 1)
  if [ ! -z "$WORKFLOW_FILE" ]; then
    sed -i '/flutter build apk/i \      - name: Clean Flutter Cache\n        run: flutter clean' "$WORKFLOW_FILE"
    echo "✅ تم تحديث ملف الـ Workflow المكتشف: $WORKFLOW_FILE"
  else
    echo "⚠️ لم نجد ملف الـ Workflow، سنقوم بعمل تعديل طفيف في الـ README لإجبار السيرفر على البناء."
    echo "Last Build Trigger: $(date)" >> README.md
  fi
fi

echo "⏳ 2. تنظيف محلي للمشروع قبل الرفع..."
flutter clean 2>/dev/null
flutter pub get 2>/dev/null

echo "⏳ 3. جاري تعميد وإضافة التعديلات للـ Git..."
git add .

echo "⏳ 4. جاري عمل الـ Commit لإجبار السيرفر على البناء النظيف..."
git commit -m "chore: force fresh build by triggering a code change and clearing cache"

echo "🚀 5. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم الرفع وإجبار السيرفر على بدء بناء جديد بالكامل! تابع البناء رقم 21 أو 22 الآن."
