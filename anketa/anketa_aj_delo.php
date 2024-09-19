<?php
// Подключаем конфиг
include ($_SERVER['DOCUMENT_ROOT']."/ini.php");

// Максимальное время выполнение скрипта
ini_set('max_execution_time', '999');

// Подключаемся к БД esed
include ($_SERVER['DOCUMENT_ROOT']."/db.php");

// Проверяем наличие сессии и org_name в ней
if (isset($_SESSION['org_name']) && !empty($_SESSION['org_name'])) {
    $org_id = (string) $_SESSION['org_id'];
} else {
    echo('Error: не авторизован!');
    die();
}

// Проверяем наличие сессии и org_access в ней
if (!isset($_SESSION['org_access']) || $_SESSION['org_access'] != true) {
    echo('Error: access');
    die();
}

// Чтобы не могли посылать пустые запросы
if (!isset($_POST['page']) && (!isset($_GET['test']) || $_GET['test'] != 'test')) {
    echo('bad access');
    die();
}

// Берём SQL запрос
$sql_zapros = file_get_contents("sql_delo.sql");

// Заменяем org_id пользователя в sql запросе. Берём из сессии
$params = [
    'org_id' => $org_id
];

// Шлём запрос в БД
$pdo_tz_zapros = $pdo_tz_connect->prepare($sql_zapros);
$pdo_tz_zapros->execute($params);

// Результат запроса в массив PHP
$sql_array = $pdo_tz_zapros->fetchAll();


// Добавляем последнюю строку 'Всего'
$sql_array[3]['name'] = 'Всего';
$sql_array[3]['Документов'] = $sql_array[2]['Документов'];
$sql_array[3]['Дел'] = $sql_array[2]['Дел'];
$sql_array[3]['Обьем'] = $sql_array[2]['Обьем'];


// Отдаём JSON клиенту
echo(json_encode($sql_array));


// echo("<pre>");
// print_r($sql_array);
// echo("</pre>");


// echo("<pre>");
// print_r($sql_array);
// echo("</pre>");


$report_type = 'anketa_delo';
if (isset($_SESSION['login']) && $_SESSION['login'] != '') {
    $login_sess = $_SESSION['login'];
} else {
    $login_sess = 'user';
}

$pdo_zapros = $pdo_connect->prepare("INSERT INTO `stats_generator` (`report_type`, `datetime`, `login`, `id`) VALUES ('$report_type', CURRENT_TIMESTAMP, '$login_sess', NULL);");
$pdo_zapros->execute();

