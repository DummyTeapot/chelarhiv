<?php 

/*
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);
*/

// Подключение к БД esed
// Только с SELECT доступом!

// Вкл/выкл сообщений об ошибка подключения и тд
if (isset($_SERVER['HTTP_HOST'])) {
    $pdo_tz_connect = new PDO("pgsql:dbname=;host=", "", "",
        array(
            PDO::ATTR_PERSISTENT => false,
            PDO::ATTR_TIMEOUT => 600, // in seconds
            PDO::ATTR_ERRMODE => PDO::ERRMODE_WARNING,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => 1 // Для нескольких запросов
        )
    );
}
