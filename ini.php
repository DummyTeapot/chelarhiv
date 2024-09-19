<?php

// Максимальное время жизни скрипт - 300 секунд
ini_set('max_execution_time', '300');

// Отключаем вывод ошибок по умолчанию
ini_set('display_errors', '0');

// Вывод ошибок (но за счёт параметра выше, они по умолчанию отключены, нужно включать в самих php скриптах)
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);

// Временная зона
date_default_timezone_set('Asia/Yekaterinburg');

// Для сессий и куки
ini_set('session.gc_maxlifetime', 7200);
ini_set('session.cookie_lifetime', 31536000);
ini_set('session.sid_length', 128);
ini_set('session.cookie_secure', 0);
ini_set('session.cookie_httponly', 0);
// ini_set('session.name', 'itr74session');

// Вырубаем кэш
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// Создаём сессию. Хранится по умолчанию на диске
session_start();

// Нужно, если в каком-то конфиге указано, что сессия уже изменяться не будет
// Чтобы страница у клиента не зависала
if (!isset($rewrite) || $rewrite != 1 ){
    session_write_close();
}


// Ошибки только для robot
if (isset($_SESSION['user_id']) && !empty($_SESSION['user_id'])) {
    $admins = [
        'd90fc014-ef10-4b9a-e5ed-a11c11e8d00f',
        'c6d4dc6e-3b8f-51b5-6d3b-03fe023505c0',
        '9641da0b-f5c6-3463-c0ae-c625d8091314'
    ];

    if (in_array($_SESSION['user_id'], $admins)) {
        ini_set('display_errors', '1');
    }
}

?>