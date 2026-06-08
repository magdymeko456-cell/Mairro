#!/bin/bash

echo "⏳ 1. تعديل إصدار مكتبة intl جوه pubspec.yaml إلى الاصدار المتوافق..."
# استبدال أي إصدار قديم لـ intl بالإصدار الإجباري 0.20.2
sed -i 's/intl: ^0.19.0/intl: ^0.20.2/g' pubspec.yaml

echo "⏳ 2. جاري إضافة وتعميد الملف للـ Git..."
git add pubspec.yaml

echo "⏳ 3. جاري عمل الـ Commit..."
git commit -m "fix: bump intl to 0.20.2 inside adopted pubspec"

echo "🚀 4. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم التعديل والرفع التلقائي يا صاحبي! راقب البناء رقم 10 الآن."
