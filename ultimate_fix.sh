#!/bin/bash

echo "⏳ 1. جلب ملف pubspec.yaml الأصلي والكامل من البناء 236..."
git checkout old_repo/main -- pubspec.yaml

echo "⏳ 2. تعديل إصدار الـ SDK وضبط الحزم لضمان استقرار البناء 18..."
# تعديل الـ SDK ليكون متوافقاً مع بيئة البناء المستقرة 18
sed -i 's/sdk: \x27>=3.4.0 <4.0.0\x27/sdk: \x27>=3.0.0 <4.0.0\x27/g' pubspec.yaml

# استبدال حزمة الفقاعة العامة بالحزمة المحلية المستقرة لحل مشكلة الـ Namespace
sed -i '/dash_bubble: ^2.0.0/c\  dash_bubble_local:\n    path: packages/dash_bubble_local' pubspec.yaml

echo "⏳ 3. جاري إضافة وتعميد الملفات للـ Git..."
git add pubspec.yaml

echo "⏳ 4. جاري عمل الـ Commit..."
git commit -m "fix: adopt complete pubspec from build 236 with stable SDK and local bubble configurations"

echo "🚀 5. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تمت العملية بنجاح يا تامر يا صاحبي! راقب البناء رقم 9 الآن."
