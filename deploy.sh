#!/bin/bash

echo "🚀 Начинаем развертывание psmo24.kz..."

# Создаем сеть если не существует
echo "🌐 Создаем Docker сеть..."
docker network create psmo24_network 2>/dev/null || echo "Сеть уже существует"

# Останавливаем старые контейнеры
echo "📦 Останавливаем старые контейнеры..."
docker-compose -f docker-compose.prod.yml down

# Удаляем старые образы
echo "🗑️ Удаляем старые образы..."
docker rmi psmo24_web || true

# Собираем новый образ
echo "🔨 Собираем новый образ..."
docker-compose -f docker-compose.prod.yml build --no-cache

# Запускаем новые контейнеры
echo "▶️ Запускаем новые контейнеры..."
docker-compose -f docker-compose.prod.yml up -d

# Проверяем статус
echo "✅ Проверяем статус контейнеров..."
docker-compose -f docker-compose.prod.yml ps

echo "🎉 Развертывание завершено!"
echo "📱 Сайт доступен по адресу: https://psmo24.kz" 