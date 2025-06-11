# Используем официальный образ PHP с Apache
FROM php:8.1-apache

# Включаем необходимые модули Apache
RUN a2enmod rewrite

# Устанавливаем дополнительные PHP расширения
RUN docker-php-ext-install mysqli

# Копируем файлы сайта
COPY . /var/www/html/

# Устанавливаем права доступа
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Конфигурация Apache для работы с .htaccess
RUN echo '<Directory /var/www/html/>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/custom.conf \
    && a2enconf custom

# Открываем порт 80
EXPOSE 80

# Запускаем Apache
CMD ["apache2-foreground"] 