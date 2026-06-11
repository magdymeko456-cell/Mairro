#!/bin/bash

WORKFLOW_FILE=".github/workflows/build.yml"

echo "⏳ 1. إعادة بناء ملف الـ Workflow الأصلي بترتيب هندسي مظبوط مية بالمية..."
mkdir -p .github/workflows

cat << 'INNER_EOF' > .github/workflows/build.yml
name: Mirror Scorpion Build  
  
on:  
  push:  
    branches: [ main, master ]  
  workflow_dispatch:  
  
jobs:  
  build:  
    runs-on: ubuntu-latest  
    steps:  
      - uses: actions/checkout@v4  
        
      - uses: actions/setup-java@v4  
        with:  
          distribution: 'zulu'  
          java-version: '17'  
            
      - uses: subosito/flutter-action@v2  
        with:  
          channel: 'stable'  
            
      - name: Prepare Project and Clean Cache
        run: |  
          set -e  
          # Get dependencies  
          flutter pub get  
            
          # Setup build directory  
          rm -rf /tmp/clean_project  
          flutter create --org com.tetocollctionway --project-name mirror_scorpion_translate /tmp/clean_project  
            
          # Copy essential files from current project  
          cp -r lib /tmp/clean_project/  
          cp -r assets /tmp/clean_project/  
          cp pubspec.yaml /tmp/clean_project/  
          cp -r packages /tmp/clean_project/  
          cp -r scripts /tmp/clean_project/  
            
          # Move to clean project  
          cd /tmp/clean_project  
          flutter pub get  
            
          # Run patch scripts  
          python3 scripts/patch_dash_bubble_compilesdk.py  
          python3 scripts/patch_gradle.py  
          python3 scripts/patch_manifest.py  
            
          # Fix SDK versions - Updated to 36 as required by latest dependencies  
          find android -name "build.gradle*" -exec sed -i 's/compileSdk .*/compileSdk = 36/g' {} +  
          find android -name "build.gradle*" -exec sed -i 's/targetSdk .*/targetSdk = 35/g' {} +  
            
          # Fix for any accidental double equals or missing spaces  
          find android -name "build.gradle*" -exec sed -i 's/==/=/g' {} +  
          find android -name "build.gradle*" -exec sed -i 's/compileSdk=/compileSdk = /g' {} +  
          find android -name "build.gradle*" -exec sed -i 's/targetSdk=/targetSdk = /g' {} +  
            
          # تنظيف الكاش داخل البيئة النظيفة قبل البدء في البناء لضمان فك التعليق
          flutter clean
          flutter pub get

          # Build APK  
          flutter build apk --release  
            
          # Move output to workspace  
          mkdir -p $GITHUB_WORKSPACE/output_apk  
          cp build/app/outputs/flutter-apk/app-release.apk $GITHUB_WORKSPACE/output_apk/  
            
      - name: Upload APK  
        uses: actions/upload-artifact@v4  
        with:  
          name: mirror-scorpion-release  
          path: output_apk/app-release.apk  
          if-no-files-found: error
INNER_EOF

echo "⏳ 2. تنظيف الأخطاء اللغوية وتصحيح مسار الـ APK المتوقع..."
# تصحيح حرف (٧) العربي اللي كان مكتوب بالخطأ في كلمة app لتصبح app سليمة للإنتقال المضمون
sed -i 's/app٧/app/g' .github/workflows/build.yml

echo "⏳ 3. تعميد الملف وإرساله للـ Git..."
git add .github/workflows/build.yml
git commit -m "fix: perfectly format original workflow script with structured clean steps"

echo "🚀 4. الرفع التلقائي المدمج إلى جيت هب..."
git push origin main

echo "✅ تم التعديل والرفع بنجاح يا تامر! تابع البناء رقم 24."
