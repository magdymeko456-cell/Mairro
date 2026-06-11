#!/bin/bash
# سكريبت بلدوزر المستقل لعمل Pull آمن ودمج التعديلات بروقان

echo "⏳ جاري سحب التعديلات من السيرفر وإعادة ترتيب كودنا المحلي (Git Pull Rebase)..."
git pull --rebase https://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@github.com/magdymeko456-cell/Mairro.git main

if [ $? -eq 0 ]; then
    echo "✅ تم الدمج بنجاح وبدون أي تعارض!"
    echo "⏳ جاري الرفع الآن إلى المستودع..."
    git push https://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@github.com/magdymeko456-cell/Mairro.git main
else
    echo "❌ حدث تعارض أثناء الدمج تلقائياً."
    echo "💡 إذا تعقدت الأمور، يمكنك إلغاء العملية عبر الأمر: git rebase --abort ثم استخدام الحل الثاني الجريء."
fi
