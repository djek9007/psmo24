#!/bin/bash

# Скрипт для автоматического обновления sitemap.xml

echo "🗺️ Обновление sitemap.xml..."

# Получаем текущую дату в формате ISO
CURRENT_DATE=$(date -u +"%Y-%m-%d")

# Обновляем дату в sitemap.xml
sed -i "s/<lastmod>.*<\/lastmod>/<lastmod>$CURRENT_DATE<\/lastmod>/g" sitemap.xml

echo "✅ Sitemap обновлен с датой: $CURRENT_DATE"

# Отправляем уведомление в Google
echo "📡 Уведомляем поисковые системы об обновлении..."

# Google
curl "https://www.google.com/ping?sitemap=https://psmo24.kz/sitemap.xml" > /dev/null 2>&1

# Bing
curl "https://www.bing.com/ping?sitemap=https://psmo24.kz/sitemap.xml" > /dev/null 2>&1

# Yandex
curl "https://webmaster.yandex.ru/ping?sitemap=https://psmo24.kz/sitemap.xml" > /dev/null 2>&1

echo "🎉 Уведомления отправлены всем поисковым системам!" 