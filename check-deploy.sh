#!/bin/bash

echo "🔍 Проверка статуса деплоя PSMO24..."
echo "========================================"

# Проверяем статус контейнеров
echo "📦 Статус контейнеров:"
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "🌐 Проверка доступности сайта:"

# Проверяем доступность на localhost
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "✅ Сайт доступен на http://localhost:8080"
else
    echo "❌ Сайт недоступен на localhost:8080"
fi

# Проверяем логи
echo ""
echo "📋 Последние логи контейнера:"
docker-compose -f docker-compose.prod.yml logs --tail=20 web-psmo24

echo ""
echo "🔧 Проверка PHP:"
docker exec psmo24_web_php php -v 2>/dev/null && echo "✅ PHP работает" || echo "❌ PHP недоступен"

echo ""
echo "📧 Проверка отправки email:"
if docker exec psmo24_web_php php -c "echo 'PHP mail() function: ' . (function_exists('mail') ? 'доступна' : 'недоступна');" 2>/dev/null; then
    echo "✅ PHP mail() функция проверена"
else
    echo "❌ Ошибка проверки mail() функции"
fi

echo ""
echo "========================================"
echo "🎯 Готово! Проверка завершена." 