#!/bin/bash

echo "🔧 Исправляем конфигурацию Apache..."

# Создаем правильную конфигурацию Apache
docker exec psmo24_web_php bash -c 'cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ServerName psmo24.kz
    
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        DirectoryIndex index.html index.php
    </Directory>
    
    # PHP обработка
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Включаем модули PHP
docker exec psmo24_web_php a2enmod php8.1
docker exec psmo24_web_php a2enmod rewrite

# Перезагружаем Apache
docker exec psmo24_web_php service apache2 reload

echo "✅ Конфигурация Apache обновлена!"
echo "🌐 Проверьте сайт: http://localhost:8080" 