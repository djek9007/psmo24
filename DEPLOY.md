# 🚀 Инструкция по деплою PSMO24

## 📋 Быстрый старт

### 1. Деплой в разработке
```bash
# Запуск с MailHog для тестирования email
./start-dev.sh

# Доступно по адресам:
# 🌐 Сайт: http://localhost:8080
# 📧 MailHog: http://localhost:8025
```

### 2. Деплой в продакшене
```bash
# Настройка SMTP (обязательно!)
cp env.example .env
nano .env  # заполните SMTP настройки

# Деплой
./deploy.sh
```

## ⚙️ Настройка SMTP для продакшена

### Gmail настройки:
1. Включите двухфакторную аутентификацию
2. Создайте App Password в настройках Google аккаунта
3. Заполните `.env` файл:

```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Yandex настройки:
```bash
SMTP_HOST=smtp.yandex.ru
SMTP_PORT=587
SMTP_USERNAME=your-email@yandex.ru
SMTP_PASSWORD=your-password
```

## 🔍 Проверка деплоя

```bash
# Полная проверка статуса
./check-deploy.sh

# Просмотр логов
docker-compose -f docker-compose.prod.yml logs -f

# Статус контейнеров
docker-compose -f docker-compose.prod.yml ps
```

## 📧 Тестирование формы

1. Откройте сайт
2. Заполните форму "Заказать демонстрацию"
3. Проверьте получение письма на `augmented.vr@gmail.com`
4. Клиент должен получить автоответ

## 🔧 Устранение проблем

### Форма не отправляется:
```bash
# Проверьте логи PHP
docker exec psmo24_web_php tail -f /var/log/apache2/error.log

# Проверьте SMTP настройки
docker exec psmo24_web_php env | grep SMTP
```

### Сайт недоступен:
```bash
# Перезапуск контейнеров
docker-compose -f docker-compose.prod.yml restart

# Полный пересбор
./deploy.sh
```

## 📁 Структура файлов

- `docker-compose.yml` - для разработки (с MailHog)
- `docker-compose.prod.yml` - для продакшена
- `Dockerfile.php` - образ с PHP и Apache
- `send_email.php` - обработчик формы
- `start-dev.sh` - запуск в разработке
- `deploy.sh` - деплой в продакшене
- `check-deploy.sh` - проверка статуса

## 🎯 Готово!

После настройки форма будет отправлять письма на `augmented.vr@gmail.com` и отправлять автоответы клиентам. 