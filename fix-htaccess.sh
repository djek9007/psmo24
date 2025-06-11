#!/bin/bash

echo "🔧 Исправляем проблему с .htaccess..."

# Включаем необходимые модули Apache
echo "📦 Включаем модули Apache..."
docker exec psmo24_web_php a2enmod rewrite
docker exec psmo24_web_php a2enmod headers
docker exec psmo24_web_php a2enmod expires
docker exec psmo24_web_php a2enmod deflate

# Проверяем содержимое .htaccess
echo "📄 Проверяем .htaccess..."
docker exec psmo24_web_php head -20 /var/www/html/.htaccess

# Создаем временный .htaccess без проблемных директив
echo "🔄 Создаем упрощенный .htaccess..."
docker exec psmo24_web_php bash -c 'cat > /var/www/html/.htaccess.backup << EOF
# Original .htaccess backed up
EOF'

# Копируем оригинальный .htaccess в backup
docker exec psmo24_web_php cp /var/www/html/.htaccess /var/www/html/.htaccess.backup

# Создаем простой .htaccess для тестирования
docker exec psmo24_web_php bash -c 'cat > /var/www/html/.htaccess << EOF
# Basic .htaccess for PSMO24
RewriteEngine On

# Security headers (простые)
<IfModule mod_headers.c>
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
</IfModule>

# Compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Cache control
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/jpg "access plus 1 month"
    ExpiresByType image/jpeg "access plus 1 month"
    ExpiresByType image/gif "access plus 1 month"
    ExpiresByType image/png "access plus 1 month"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/pdf "access plus 1 month"
    ExpiresByType text/javascript "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>
EOF'

# Перезапускаем Apache
echo "🔄 Перезапускаем Apache..."
docker exec psmo24_web_php service apache2 reload

# Проверяем результат
echo "✅ Проверяем сайт..."
sleep 2

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "🎉 Сайт работает! http://localhost:8080"
else
    echo "❌ Все еще ошибка, проверяем логи..."
    docker exec psmo24_web_php tail -5 /var/log/apache2/error.log
fi

echo "✅ Готово!" 