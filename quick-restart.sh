#!/bin/bash

echo "⚡ Быстрый перезапуск PSMO24..."

# Останавливаем все docker-compose
docker-compose -f docker-compose.prod.yml down
docker-compose down 2>/dev/null || true

# Проверяем порт 8080
echo "🔍 Проверяем порт 8080..."
if ss -tlnp | grep :8080 > /dev/null 2>&1; then
    echo "❗ Порт 8080 занят"
    ss -tlnp | grep :8080
else
    echo "✅ Порт 8080 свободен"
fi

# Запускаем без пересборки
echo "▶️ Запускаем контейнеры..."
docker-compose -f docker-compose.prod.yml up -d

echo "⏳ Ждем 3 секунды..."
sleep 3

echo "📋 Статус:"
docker-compose -f docker-compose.prod.yml ps

echo "🌐 Проверяем сайт..."
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080

echo "✅ Готово!" 