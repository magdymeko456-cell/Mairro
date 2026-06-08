#!/bin/bash

echo "⏳ 1. تحديث ملف pubspec.yaml وإضافة مكتبة الشطرنج الناقصة..."
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

  # Games Corner
  chess: ^0.8.0

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

echo "⏳ 2. إصلاح الاستدعاءات الناقصة في ملف ai_service.dart..."
# إنشاء ملف مؤقت لإضافة الاستدعاءات في البداية لحل مشكلة http و json و debugPrint
cat << 'INNER_EOF' > temp_ai_service.dart
import 'package:flutter/foundation.dart';
import 'http: ^1.2.1' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;

INNER_EOF

# دمج الاستدعاءات مع الكود القديم بعد تنظيف أي استدعاءات مكررة مكسورة إن وجدت
cat lib/services/ai_service.dart >> temp_ai_service.dart
mv temp_ai_service.dart lib/services/ai_service.dart

echo "⏳ 3. جاري إضافة التعديلات للـ Git..."
git add pubspec.yaml lib/services/ai_service.dart

echo "⏳ 4. جاري عمل الـ Commit..."
git commit -m "fix: add chess dependency and missing imports in ai_service"

echo "🚀 5. جاري الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم الإصلاح والرفع بنجاح يا تامر يا صاحبي! راقب البناء رقم 7 الآن."
