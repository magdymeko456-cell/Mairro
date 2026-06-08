#!/bin/bash

# 1. إعادة كتابة ملف pubspec.yaml بالاعتماد على الحزمة المحلية المستقرة
cat << 'INNER_EOF' > pubspec.yaml
name: mirror_scorpion_v2
description: "Mirror Scorpion Premium - حيث تُصنع البدايات"
publish_to: 'none'
version: 1.2.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # UI & Design
  cupertino_icons: ^1.0.8
  provider: ^6.1.2

  # Networking, AI & Translation
  http: ^1.2.1
  google_generative_ai: ^0.4.6

  # Storage & Database
  shared_preferences: ^2.3.3
  sqflite: ^2.3.3+1
  path_provider: ^2.1.4

  # Text-to-Speech & Speech Recognition
  flutter_tts: ^4.1.0
  speech_to_text: ^7.3.0

  # Image, Camera & OCR
  google_mlkit_text_recognition: ^0.13.1
  image_picker: ^1.1.2
  camera: ^0.11.0+2
  camera_android_camerax: ^0.6.5+1

  # System Utilities & Sharing
  share_plus: ^10.1.4
  permission_handler: ^11.3.1
  device_info_plus: ^11.2.1
  clipboard: ^0.1.3
  intl: ^0.20.2
  webview_flutter: ^4.10.0
  
  # العودة للفقاعة المحلية المستقرة لحل تعارض الـ Namespace
  dash_bubble_local:
    path: packages/dash_bubble_local

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/scorpion_icon.jpeg"
  min_sdk_android: 21

flutter:
  uses-material-design: true
  assets:
    - assets/data/hadiths.json
    - assets/data/hadith_qudsi.json
    - assets/data/quran_stories.json
    - assets/data/stories.json
    - assets/images/scorpion_icon.jpeg
INNER_EOF

# 2. تشغيل أوامر الرفع التلقائية المدمجة
echo "⏳ جاري إضافة التعديلات..."
git add pubspec.yaml

echo "⏳ جاري عمل الـ Commit..."
git commit -m "fix: restore dash_bubble_local to resolve namespace conflict"

echo "🚀 جاري الرفع التلقائي إلى جيت هب..."
git push origin main

echo "✅ تم التعديل والرفع بنجاح يا تامر يا صاحبي! تابع الـ Actions الآن."
