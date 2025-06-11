#!/bin/bash

echo "🔄 Автоматическое обновление psmo24.kz..."

# Переходим в директорию проекта
cd /opt/psmo24

# Проверяем изменения в Git
git fetch origin main

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ $LOCAL != $REMOTE ]; then
    echo "📥 Найдены новые изменения, обновляем..."
    
    # Загружаем изменения
    git pull origin main
    
    # Перезапускаем сайт
    ./deploy.sh
    
    echo "✅ Обновление завершено!"
else
    echo "ℹ️ Изменений нет"
fi 