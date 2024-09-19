<?php
// Подключаем конфиг
include ($_SERVER['DOCUMENT_ROOT']."/ini.php");

// Проверяем наличие сессии и org_name в ней
if (isset($_SESSION['org_name']) && !empty($_SESSION['org_name'])) {
    $org_name = (string) $_SESSION['org_name'];
    $org_auth_style = '';
} else {
    $org_name = 'Необходимо авторизоваться в генераторе отчётов!';
    $org_auth_style = 'org_auth_style';
}

?>

<div class="main-content last_aurh_page container-lg mt-4">

    <div class="main-content-aj">

        <div class="aj-container aj-container-anketa">

            <div class="row align-items-end mt-3">
                <div class="col">
                    <div class="main-content-name">
                        <p class="anketa_page_name">Анкета 2023</p>
                        <p class="report_org_name <?php echo($org_auth_style)?>"><?php echo($org_name)?></p>
                        <p class="mt-5 anketa-warning">Среднее время выгрузки отчётов 1.2, 1.3 и 1.7 примерно 3 минуты!</p>
                    </div>
                </div>

                <?php

                    // if (isset($_SESSION['org_access']) && $_SESSION['org_access'] == true) {
                    //     echo("
                    //     <div class='col-md-2'>
                    //         <button class='mt-3 aj-getreport aj-get-anketa form-control'>Получить отчет
                    //             <div id='loading-icon' class='spinner-border spinner-border-sm aj_get_loading' role='status'>
                    //             </div>
                    //         </button>
                    //     </div>
                    // ");
                    // }

                ?>

            </div>

            <?php 

                if (!isset($_SESSION['org_access']) || $_SESSION['org_access'] != true) {
                    echo("
                    <div class='row mt-3 not-access'>
                        <div class='col'>
                            <p>Выгрузка отчёта доступна только для руководителя организации и регистраторов!</p>
                        </div>
                    </div>
                ");
                }

            ?>

            


            
        </div>



        <div class="main-count-save-anketa">
            <button class='aj-getreport aj-get-anketa aj-get-anketa-vh form-control'>1. Получить отчет
                <div id='loading-icon' class='spinner-border spinner-border-sm aj_get_loading' role='status'>
                </div>
            </button>
            <button class="aj-savereport-vh form-control">2. Сохранить отчёт
            </button>
        </div>

        <div class="table-wrapper table-wrapper-anketa table-wrapper-in">
            <table class="table table-hover table-bordered table-left table-down dt-on table-vh" id="table-vh">
                <thead id="table-head">
                    <tr>
                        <td colspan="5">1.2. Количество поступивших (входящих) документов*:</td>
                    </tr>
                    <tr>
                        <td rowspan="3"></td>
                        <td colspan="4">2023</td>
                    </tr>
                    <tr>
                        <td rowspan="2">Всего отправленных</td>
                        <td colspan="3">Из них</td>
                    </tr>
                    <tr>
                        <td>Не подписанных УКЭП</td>
                        <td>Подписанных УКЭП</td>
                        <td>Имеющих вложения</td>
                    </tr>
                    <tr>
                        <td>Запросов  членов Совета Федерации, депутатов Государственной Думы</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                    <td>Правительство РФ, Администрация Президента РФ</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из  федеральных органов исполнительной власти, федеральных организаций</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Аппарата Губернатора ЧО и Правительства ЧО</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>От заместителей Губернатора Челябинской области</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из управлений Правительства Челябинской области</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из Законодательного Собрания Челябинской области</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из исполнительных органов Челябинской области</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из исполнительных органов субъектов Российской Федерации,  госутрственных организаций, органов местного самоуправления иных регионов</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из подведомственных организаций</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из органов местного самоуправления Челябинской области</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из отраслевых органов местного самоуправления,  муниципальных организаций</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Из иных организаций</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>От граждан (обращения, запросы)</td>
                        <td>нет в сэд</td>
                        <td>нет в сэд</td>
                        <td>нет в сэд</td>
                        <td>нет в сэд</td>
                    </tr>
                    <tr>
                        <td>Всего</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </thead>
                <tbody id="tbody-vh">

                </tbody>
            </table>
        </div>
    </div>



    <div class="main-count-save-anketa">
        <button class='aj-getreport aj-get-anketa aj-get-anketa-ish form-control'>1. Получить отчет
            <div id='loading-icon' class='spinner-border spinner-border-sm aj_get_loading' role='status'>
            </div>
        </button>
        <button class="aj-savereport-ish form-control">2. Сохранить отчёт
        </button>
    </div>
    <div class="table-wrapper table-wrapper-anketa table-wrapper-out">
        <table class="table table-hover table-bordered table-left table-down dt-on table-ish" id="table-ish">
            <thead id="table-head">
                <tr>
                    <td colspan="5">1.3. Количество отправленных (исходящих) документов*:</td>
                </tr>
                <tr>
                    <td rowspan="3"></td>
                    <td colspan="4">2023</td>
                </tr>
                <tr>
                    <td rowspan="2">Всего отправленных</td>
                    <td colspan="3">Из них</td>
                </tr>
                <tr>
                    <td>Не подписанных УКЭП</td>
                    <td>Подписанных УКЭП</td>
                    <td>Имеющих вложения</td>
                </tr>
                <tr>
                    <td>Ответ на запрос  членов Совета Федерации, депутатов Государственной Думы</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>В Правительство РФ, Администрацию Президента РФ</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>В федеральные органы исполнительной власти, федеральные организации</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>В Аппарат Губернатора ЧО и Правительства ЧО</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Заместителю Губернатора Челябинской области</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Управлению Правительства Челябинской области</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Законодательному Собранию Челябинской области</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Исполнительным органам Челябинской области</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Исполнительным органам  субъектов Российской Федерации,  государственным организациям, органам местного самоуправления иных регионов</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Подведомственных организаций</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Органам местного самоуправления Челябинской области</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Отраслевым органам местного самоуправления,  муниципальным организациям</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Иным организациям</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Гражданам (ответ на обращения, запросы)</td>
                    <td>нет в сэд</td>
                    <td>нет в сэд</td>
                    <td>нет в сэд</td>
                    <td>нет в сэд</td>
                </tr>
                <tr>
                    <td>Всего:</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </thead>
            <tbody id="tbody-ish">

            </tbody>
        </table>
    </div>



    <div class="main-count-save-anketa">
        <button class='aj-getreport aj-get-anketa aj-get-anketa-vn form-control'>1. Получить отчет
            <div id='loading-icon' class='spinner-border spinner-border-sm aj_get_loading' role='status'>
            </div>
        </button>
        <button class="aj-savereport-vn form-control">2. Сохранить отчёт
        </button>
    </div>
    <div class="table-wrapper table-wrapper-anketa table-wrapper-anketa-last table-wrapper-vn">
        <table class="table table-hover table-bordered table-left table-down dt-on table-vn" id="table-vn">
            <thead id="table-head">
                <tr>
                    <td colspan="5">1.4. Количество внутренних документов:</td>
                </tr>
                <tr>
                    <td rowspan="3"></td>
                    <td colspan="4">2023</td>
                </tr>
                <tr>
                    <td rowspan="2">Всего отправленных</td>
                    <td colspan="3">Из них</td>
                </tr>
                <tr>
                    <td>Не подписанных УКЭП</td>
                    <td>Подписанных УКЭП</td>
                    <td>Имеющих вложения</td>
                </tr>
                <tr>
                    <td>НПА</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Служебные записки</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Поручения*</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Всего</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </thead>
            <tbody id="tbody-vn">

            </tbody>
        </table>
    </div>




    <div class="main-count-save-anketa">
        <button class='aj-getreport aj-get-anketa aj-get-anketa-delo form-control'>1. Получить отчет
            <div id='loading-icon' class='spinner-border spinner-border-sm aj_get_loading' role='status'>
            </div>
        </button>
        <button class="aj-savereport-delo form-control">2. Сохранить отчёт
        </button>
    </div>
    <div class="table-wrapper table-wrapper-anketa table-wrapper-anketa-last table-wrapper-delo">
        <table class="table table-hover table-bordered table-left table-down dt-on table-delo" id="table-delo">
            <thead id="table-head">
                <tr>
                    <td colspan="4">1.7. Количество электронных документов (единиц, Мб). временных (до 10 лет включительно), временных (свыше 10 лет) сроков хранения и постоянного срока хранения, созданных и существующих в организации только в электронном виде (без создания документа на бумажном носителе), включенных в электронные дела в соответствии с утвержденной номенклатурой дел:</td>
                </tr>
                <tr>
			        <td rowspan="2"></td>
			        <td colspan="3">2023</td>
                </tr>
                <tr>
                    <td>Документов</td>
                    <td>Дел</td>
                    <td>Объем, Мбайт</td>
                </tr>
                <tr>
                    <td>До 10 лет (включительно)</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                </tr>
                <tr>
                    <td>Временных (свыше 10 лет) сроков хранения</td>
                    <td>0</td>
                    <td>0</td>
                    <td>0</td>
                </tr>
                <tr>
                    <td>Постоянного срока хранения</td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Всего:</td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </thead>
            <tbody id="tbody-vn">

            </tbody>
        </table>
    </div>




</div>