#!/bin/bash

echo "🧹 Полная очистка и перезапуск PSMO24..."
echo "========================================="

# Останавливаем ВСЕ контейнеры связанные с psmo24
echo "🛑 Останавливаем все контейнеры psmo24..."
docker stop $(docker ps -q --filter "name=psmo24") 2>/dev/null || echo "Нет запущенных контейнеров psmo24"

# Удаляем все контейнеры psmo24
echo "🗑️ Удаляем старые контейнеры..."
docker rm $(docker ps -aq --filter "name=psmo24") 2>/dev/null || echo "Нет контейнеров для удаления"

# Проверяем что освободили порт 8080
echo "🔍 Проверяем порт 8080..."
if netstat -tlnp | grep :8080 > /dev/null; then
    echo "❗ Порт 8080 все еще занят. Проверяем что именно:"
    netstat -tlnp | grep :8080
    echo "Попробуем найти и остановить процесс..."
    sudo fuser -k 8080/tcp 2>/dev/null || echo "Процесс не найден или уже остановлен"
else
    echo "✅ Порт 8080 свободен"
fi

# Останавливаем docker-compose проекты
echo "📦 Останавливаем все docker-compose конфигурации..."
docker-compose down 2>/dev/null || echo "docker-compose.yml не найден"
docker-compose -f docker-compose.prod.yml down 2>/dev/null || echo "docker-compose.prod.yml уже остановлен"
docker-compose -f docker-compose.simple.yml down 2>/dev/null || echo "docker-compose.simple.yml не найден"

# Удаляем старые образы
echo "🗑️ Удаляем старые образы..."
docker rmi psmo24_web_php 2>/dev/null || echo "Образ psmo24_web_php не найден"
docker rmi psmo24_web 2>/dev/null || echo "Образ psmo24_web не найден"
docker rmi $(docker images -q --filter "reference=psmo24*") 2>/dev/null || echo "Других образов psmo24 не найдено"

# Очищаем неиспользуемые ресурсы
echo "🧽 Очищаем неиспользуемые Docker ресурсы..."
docker system prune -f

echo ""
echo "🚀 Запускаем новую версию..."
echo "============================="

# Создаем сеть если не существует
docker network create psmo24_network 2>/dev/null || echo "Сеть уже существует"

# Собираем и запускаем новую версию
echo "🔨 Собираем новый образ..."
docker-compose -f docker-compose.prod.yml build --no-cache

echo "▶️ Запускаем новые контейнеры..."
docker-compose -f docker-compose.prod.yml up -d

# Ждем немного для запуска
echo "⏳ Ждем запуска контейнеров..."
sleep 5

# Проверяем результат
echo ""
echo "✅ Проверяем статус..."
echo "====================="
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "🌐 Проверяем доступность сайта..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "✅ Сайт доступен на http://localhost:8080"
else
    echo "❌ Сайт пока недоступен, проверяем логи..."
    docker-compose -f docker-compose.prod.yml logs --tail=10
fi

echo ""
echo "🎉 Готово! Новая версия запущена." 