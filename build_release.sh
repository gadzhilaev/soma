#!/bin/bash

# Скрипт для сборки релизного APK файла
# Использование: ./build_release.sh

echo "🧹 Очистка проекта..."
flutter clean

echo "📦 Установка зависимостей..."
flutter pub get

echo "🔨 Сборка релизного APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo "✅ APK успешно собран!"
    echo "📱 Файл находится в: build/app/outputs/flutter-apk/app-release.apk"
    
    # Копируем APK в корень проекта для удобства
    cp build/app/outputs/flutter-apk/app-release.apk ./soma-release.apk
    echo "📋 APK также скопирован в: ./soma-release.apk"
else
    echo "❌ Ошибка при сборке APK"
    exit 1
fi

