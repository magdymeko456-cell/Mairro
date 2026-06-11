#!/bin/bash

echo "⏳ 1. جاري مسح ملف الـ Workflow المعطوب تماماً..."
rm -f .github/workflows/build.yml

echo "⏳ 2. استعادة النسخة الأصلية والمستقرة تماماً من جيت هب بدون أي تعديل نصي..."
git checkout origin/main -- .github/workflows/build.yml 2>/dev/null || git checkout HEAD~3 -- .github/workflows/build.yml

echo "⏳ 3. تعميد وإضافة الملف الأصلي السليم للـ Git..."
git add .github/workflows/build.yml

echo "⏳ 4. جاري عمل الـ Commit النظيف..."
git commit -m "fix: strictly restore original stable workflow configuration file to repair yaml syntax"

echo "🚀 5. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم إعادة ملفك القديم والأصلي بنجاح يا تامر! راقب البناء رقم 23 الآن."
