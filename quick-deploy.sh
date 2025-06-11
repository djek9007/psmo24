#!/bin/bash

echo "🚀 Быстрое развертывание psmo24.kz..."

# Останавливаем и удаляем старый контейнер
echo "📦 Останавливаем старый контейнер..."
docker stop psmo24_web 2>/dev/null || true
docker rm psmo24_web 2>/dev/null || true

# Удаляем старый образ
echo "🗑️ Удаляем старый образ..."
docker rmi psmo24_web 2>/dev/null || true

# Собираем новый образ
echo "🔨 Собираем новый образ..."
docker-compose -f docker-compose.simple.yml build --no-cache

# Запускаем новый контейнер
echo "▶️ Запускаем новый контейнер..."
docker-compose -f docker-compose.simple.yml up -d

# Проверяем статус
echo "✅ Проверяем статус контейнера..."
docker ps | grep psmo24_web

# Показываем логи
echo "📋 Последние логи:"
docker logs psmo24_web --tail 10

echo "🎉 Развертывание завершено!"
echo "📱 Сайт доступен по адресу: http://$(hostname -I | awk '{print $1}'):8080"
echo "🌐 Или по адресу: https://psmo24.kz (если настроен proxy)" 