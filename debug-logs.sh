#!/bin/bash

echo "🔍 Диагностика ошибок PSMO24..."
echo "==============================="

echo "📋 Статус контейнера:"
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "📧 Логи Apache error.log:"
docker exec psmo24_web_php tail -20 /var/log/apache2/error.log

echo ""
echo "📧 Логи Apache access.log:"
docker exec psmo24_web_php tail -10 /var/log/apache2/access.log

echo ""
echo "🔧 Проверка PHP:"
docker exec psmo24_web_php php -v

echo ""
echo "📁 Проверка файлов в контейнере:"
docker exec psmo24_web_php ls -la /var/www/html/

echo ""
echo "🔍 Проверка прав доступа:"
docker exec psmo24_web_php ls -la /var/www/html/index.html

echo ""
echo "📧 Проверка send_email.php:"
docker exec psmo24_web_php ls -la /var/www/html/send_email.php

echo ""
echo "🧪 Тестируем простой PHP:"
docker exec psmo24_web_php bash -c 'echo "<?php phpinfo(); ?>" > /var/www/html/test.php'
echo "Тест доступен: http://localhost:8080/test.php"

echo ""
echo "🔍 Проверка синтаксиса PHP:"
docker exec psmo24_web_php php -l /var/www/html/send_email.php

echo ""
echo "✅ Диагностика завершена!" 