#!/bin/bash

echo "🔧 Исправляем проблему с редиректами..."

# Останавливаем контейнер
echo "🛑 Останавливаем контейнер..."
docker stop psmo24_web

# Удаляем контейнер
echo "🗑️ Удаляем контейнер..."
docker rm psmo24_web

# Пересобираем образ с исправленной конфигурацией
echo "🔨 Пересобираем образ..."
docker build -t psmo24_web .

# Запускаем контейнер
echo "▶️ Запускаем контейнер..."
docker run -d --name psmo24_web -p 8080:80 --restart unless-stopped psmo24_web

# Ждем запуска
sleep 3

echo "✅ Тестируем сайт..."
curl -I http://localhost:8080

echo ""
echo "📋 Логи контейнера:"
docker logs psmo24_web --tail 5

echo ""
echo "🎉 Готово! Проверьте сайт в браузере: http://IP_СЕРВЕРА:8080" 