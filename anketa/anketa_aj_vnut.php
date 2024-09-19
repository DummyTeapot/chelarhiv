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
$sql_zapros = file_get_contents("sql_vnut.sql");

// Заменяем org_id пользователя в sql запросе
// Берём из сессии
$params = [
    'org_id' => $org_id
];

// Шлём запрос в БД
$pdo_tz_zapros = $pdo_tz_connect->prepare($sql_zapros);
$pdo_tz_zapros->execute($params);

// Результат запроса в массив PHP
$sql_array = $pdo_tz_zapros->fetchAll();


// По умолчанию ВСЕГО внутренних делаем по нулям
$vsego_otprav = 0;
$vsego_noeds = 0;
$vsego_eds = 0;
$vsego_vloz = 0;

// Убираем столбец с сортировкой
// Он был необходим для правильного визуального вывода
for ($i = 0; $i < count($sql_array); $i++) {
    unset($sql_array[$i]['sort']);
}


// Добавляем для ВСЕГО количество всех значений выше, которые в результате SQL
for ($i = 0; $i < count($sql_array); $i++) {

    $vsego_otprav += $sql_array[$i]['Всего внутренних'];
    $vsego_noeds += $sql_array[$i]['Не подписанных УКЭП'];
    $vsego_eds += $sql_array[$i]['Подписанных УКЭП'];
    $vsego_vloz += $sql_array[$i]['Имеющих вложения'];

}


// Добавляем новый столбец-элемент ВСЕГО для массива
$sql_array[3]['name'] = 'Всего';
$sql_array[3]['Всего внутренних'] = $vsego_otprav;
$sql_array[3]['Не подписанных УКЭП'] = $vsego_noeds;
$sql_array[3]['Подписанных УКЭП'] = $vsego_eds;
$sql_array[3]['Имеющих вложения'] = $vsego_vloz;


// отдаём клиенту json
echo(json_encode($sql_array));


// echo("<pre>");
// print_r($sql_array);
// echo("</pre>");


// echo("<pre>");
// print_r( $sql_array );
// echo("</pre>");



$report_type = 'anketa_vnut';
if (isset($_SESSION['login']) && $_SESSION['login'] != '') {
    $login_sess = $_SESSION['login'];
} else {
    $login_sess = 'user';
}

$pdo_zapros = $pdo_connect->prepare("INSERT INTO `stats_generator` (`report_type`, `datetime`, `login`, `id`) VALUES ('$report_type', CURRENT_TIMESTAMP, '$login_sess', NULL);");
$pdo_zapros->execute();

