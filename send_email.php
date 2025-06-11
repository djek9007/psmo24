<?php
// Включаем отображение ошибок для отладки (убрать в продакшене)
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Метод не разрешен']);
    exit;
}

// Получаем данные из формы
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    $input = $_POST;
}

// Валидация обязательных полей
$required_fields = ['name', 'company', 'phone', 'email'];
$missing_fields = [];

foreach ($required_fields as $field) {
    if (empty($input[$field])) {
        $missing_fields[] = $field;
    }
}

if (!empty($missing_fields)) {
    echo json_encode([
        'success' => false, 
        'message' => 'Заполните обязательные поля: ' . implode(', ', $missing_fields)
    ]);
    exit;
}

// Валидация email
if (!filter_var($input['email'], FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'message' => 'Некорректный email адрес']);
    exit;
}

// Настройки почты
$to = 'augmented.vr@gmail.com';
$subject = 'Новая заявка на демонстрацию PSMO24 от ' . $input['name'] . ' (' . $input['company'] . ')';

// Формируем содержимое письма
$message = "
<html>
<head>
    <meta charset='UTF-8'>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .header { background: linear-gradient(135deg, #2563eb, #06b6d4); color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; }
        .field { margin-bottom: 15px; }
        .label { font-weight: bold; color: #2563eb; }
        .value { margin-left: 10px; }
        .footer { background: #f8f9fa; padding: 15px; text-align: center; margin-top: 20px; }
    </style>
</head>
<body>
    <div class='header'>
        <h2>🚀 Новая заявка на демонстрацию PSMO24</h2>
    </div>
    
    <div class='content'>
        <h3>Информация о клиенте:</h3>
        
        <div class='field'>
            <span class='label'>👤 Имя:</span>
            <span class='value'>" . htmlspecialchars($input['name']) . "</span>
        </div>
        
        <div class='field'>
            <span class='label'>🏢 Компания:</span>
            <span class='value'>" . htmlspecialchars($input['company']) . "</span>
        </div>
        
        <div class='field'>
            <span class='label'>💼 Должность:</span>
            <span class='value'>" . (isset($input['position']) && !empty($input['position']) ? htmlspecialchars($input['position']) : 'Не указано') . "</span>
        </div>
        
        <div class='field'>
            <span class='label'>📞 Телефон:</span>
            <span class='value'>" . htmlspecialchars($input['phone']) . "</span>
        </div>
        
        <div class='field'>
            <span class='label'>📧 Email:</span>
            <span class='value'>" . htmlspecialchars($input['email']) . "</span>
        </div>
        
        <div class='field'>
            <span class='label'>👥 Количество сотрудников:</span>
            <span class='value'>" . (isset($input['employees']) && !empty($input['employees']) ? htmlspecialchars($input['employees']) : 'Не указано') . "</span>
        </div>
        
        <div class='field'>
            <span class='label'>💬 Дополнительная информация:</span>
            <div style='margin-top: 10px; padding: 15px; background: #f8f9fa; border-left: 4px solid #2563eb;'>
                " . (isset($input['message']) && !empty($input['message']) ? nl2br(htmlspecialchars($input['message'])) : 'Не указано') . "
            </div>
        </div>
        
        <div class='field'>
            <span class='label'>📅 Дата заявки:</span>
            <span class='value'>" . date('d.m.Y H:i:s') . "</span>
        </div>
    </div>
    
    <div class='footer'>
        <p><strong>Система PSMO24</strong> - Автоматизация предсменных и послесменных медосмотров</p>
        <p>Свяжитесь с клиентом в течение 2 часов для максимальной конверсии!</p>
    </div>
</body>
</html>
";

// Настройки SMTP (для продакшена)
$smtp_config = [
    'host' => getenv('SMTP_HOST') ?: 'localhost',
    'port' => getenv('SMTP_PORT') ?: 1025,
    'username' => getenv('SMTP_USERNAME') ?: '',
    'password' => getenv('SMTP_PASSWORD') ?: '',
];

// Заголовки для HTML письма
$headers = [
    'MIME-Version: 1.0',
    'Content-Type: text/html; charset=UTF-8',
    'From: PSMO24 System <noreply@psmo24.kz>',
    'Reply-To: ' . $input['email'],
    'X-Mailer: PHP/' . phpversion(),
    'X-Priority: 1',
    'Importance: High'
];

try {
    // Проверяем, используем ли MailHog для тестирования
    if ($smtp_config['host'] === 'localhost' && $smtp_config['port'] == 1025) {
        // Настройка для MailHog
        ini_set('SMTP', 'mailhog');
        ini_set('smtp_port', 1025);
    }
    
    // Отправляем письмо
    $success = mail($to, $subject, $message, implode("\r\n", $headers));
    
    if (!$success) {
        throw new Exception('Не удалось отправить письмо');
    }
    
    // Отправляем автоответ клиенту
    $client_subject = 'Спасибо за интерес к PSMO24! Ваша заявка принята';
    $client_message = "
    <html>
    <head>
        <meta charset='UTF-8'>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .header { background: linear-gradient(135deg, #2563eb, #06b6d4); color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; }
            .footer { background: #f8f9fa; padding: 15px; text-align: center; margin-top: 20px; }
        </style>
    </head>
    <body>
        <div class='header'>
            <h2>✅ Ваша заявка принята!</h2>
        </div>
        
        <div class='content'>
            <p>Здравствуйте, <strong>" . htmlspecialchars($input['name']) . "</strong>!</p>
            
            <p>Спасибо за интерес к системе PSMO24 - комплексной системе автоматизации предсменных и послесменных медосмотров.</p>
            
            <p><strong>Что дальше?</strong></p>
            <ul>
                <li>🕐 Наш менеджер свяжется с вами в течение 2 часов</li>
                <li>📋 Проведем анализ ваших потребностей</li>
                <li>🎯 Подготовим персональное предложение</li>
                <li>🚀 Организуем демонстрацию системы</li>
            </ul>
            
            <p><strong>Преимущества PSMO24:</strong></p>
            <ul>
                <li>⚡ Медосмотр за 60 секунд</li>
                <li>🇰🇿 Казахстанское производство</li>
                <li>💰 Экономия до 80% на медперсонале</li>
                <li>📱 Полная автоматизация процесса</li>
            </ul>
            
            <p>Если у вас есть срочные вопросы, звоните:</p>
            <p><strong>📞 +7 702 149 1010</strong></p>
        </div>
        
        <div class='footer'>
            <p><strong>PSMO24</strong> - Будущее медицинского контроля уже здесь</p>
        </div>
    </body>
    </html>
    ";
    
    $client_headers = [
        'MIME-Version: 1.0',
        'Content-Type: text/html; charset=UTF-8',
        'From: PSMO24 Team <augmented.vr@gmail.com>',
        'X-Mailer: PHP/' . phpversion()
    ];
    
    mail($input['email'], $client_subject, $client_message, implode("\r\n", $client_headers));
    
    // Логируем заявку
    $log_entry = date('Y-m-d H:i:s') . " - Новая заявка от " . $input['name'] . " (" . $input['email'] . ")\n";
    file_put_contents('contact_log.txt', $log_entry, FILE_APPEND | LOCK_EX);
    
    echo json_encode([
        'success' => true, 
        'message' => 'Спасибо! Ваша заявка отправлена. Мы свяжемся с вами в течение 2 часов.'
    ]);
    
} catch (Exception $e) {
    error_log('Email sending error: ' . $e->getMessage());
    echo json_encode([
        'success' => false, 
        'message' => 'Произошла ошибка при отправке. Попробуйте еще раз или свяжитесь с нами по телефону.'
    ]);
}
?> 