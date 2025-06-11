#!/bin/bash

echo "🔧 Исправляем nginx конфигурацию и перезапускаем..."

# Останавливаем и удаляем поврежденный контейнер
echo "🛑 Останавливаем поврежденный контейнер..."
docker stop psmo24_web 2>/dev/null || true
docker rm psmo24_web 2>/dev/null || true

# Удаляем поврежденный образ
echo "🗑️ Удаляем поврежденный образ..."
docker rmi $(docker images | grep psmo24 | awk '{print $3}') 2>/dev/null || true

# Пересобираем образ с исправленной конфигурацией
echo "🔨 Пересобираем образ..."
docker build -t psmo24_web .

# Запускаем новый контейнер
echo "▶️ Запускаем исправленный контейнер..."
docker run -d --name psmo24_web -p 8080:80 --restart unless-stopped psmo24_web

# Ждем немного для запуска
sleep 3

# Проверяем статус
echo "✅ Проверяем статус..."
docker ps | grep psmo24_web

# Показываем логи
echo "📋 Логи контейнера:"
docker logs psmo24_web

# Тестируем доступность
echo "🌐 Тестируем доступность..."
curl -I http://localhost:8080 || echo "❌ Сайт недоступен"

echo "🎉 Готово! Сайт должен быть доступен на порту 8080" 