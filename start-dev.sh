#!/bin/bash

echo "🚀 Запуск PSMO24 в режиме разработки..."

# Останавливаем существующие контейнеры
echo "📦 Останавливаем существующие контейнеры..."
docker-compose down

# Собираем и запускаем контейнеры
echo "🔨 Собираем Docker образ..."
docker-compose up --build -d

# Проверяем статус
echo "✅ Проверяем статус контейнеров..."
docker-compose ps

echo ""
echo "🌐 Сайт доступен по адресу: http://localhost:8080"
echo "📧 MailHog (тестирование почты): http://localhost:8025"
echo ""
echo "📝 Для просмотра логов: docker-compose logs -f"
echo "🛑 Для остановки: docker-compose down"
echo ""
echo "✨ Готово! Теперь форма обратной связи будет работать." 