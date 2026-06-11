#!/bin/bash
# سكريبت بلدوزر لإنهاء الـ Rebase المعلق وفرض رفع كود ميرور سكربيون الصافي

echo "⏳ جاري إلغاء عملية الـ Rebase المعلقة لتنظيف البيئة..."
git rebase --abort

echo "🚀 جاري تفعيل بند البلدوزر: فرض رفع كودك الحالي ومسح أي تعارض على السيرفر..."
git push -f https://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@github.com/magdymeko456-cell/Mairro.git main

if [ $? -eq 0 ]; then
    echo "✅ تم الرفع بالقوة بنجاح يا تامر! المستودع الآن يطابق جهازك 100%."
    echo "🎯 سيرفرات GitHub بدأت الآن بناء الـ APK المستقر لتطبيق Mirror Scorpion."
else
    echo "❌ فشل الرفع، يرجى التأكد من اتصال الإنترنت."
fi
