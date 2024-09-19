-- :org_id заменяется с помощью php PDO на id организации пользователя, который делает запрос
-- Сам id берётся из php сессии после авторизации в генераторе отчётов
-- Запросы состовлялись из требований бизнес-аналитиков



SELECT

ish_sov_fed_23.name,
ish_sov_fed_23."Всего отправленных",
ish_sov_fed_23."Всего отправленных" - ish_sov_fed_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_sov_fed_eds_23."Подписанных УКЭП",
ish_sov_fed_vloz_23."Имеющих вложения",
1 AS "sort"


FROM

(

SELECT
'Ответ на запрос  членов Совета Федерации, депутатов Государственной Думы' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%совет федер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

  

) AS ish_sov_fed_23



LEFT JOIN

(

SELECT
'Ответ на запрос  членов Совета Федерации, депутатов Государственной Думы' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%совет федер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL

) AS ish_sov_fed_eds_23
ON ish_sov_fed_eds_23.name = ish_sov_fed_23.name


LEFT JOIN

(

SELECT
'Ответ на запрос  членов Совета Федерации, депутатов Государственной Думы' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%совет федер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_sov_fed_vloz_23
ON ish_sov_fed_vloz_23.name = ish_sov_fed_23.name




UNION
--В Правительство РФ, Администрацию Президента РФ


SELECT

ish_prav_rf_23.name,
ish_prav_rf_23."Всего отправленных",
ish_prav_rf_23."Всего отправленных" - ish_prav_rf_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_prav_rf_eds_23."Подписанных УКЭП",
ish_prav_rf_vloz_23."Имеющих вложения",
2 AS "sort"


FROM

(

SELECT
'В Правительство РФ, Администрацию Президента РФ' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%администрация президента российской федерации (мэдо)%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_prav_rf_23



LEFT JOIN

(

SELECT
'В Правительство РФ, Администрацию Президента РФ' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%администрация президента российской федерации (мэдо)%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.card_id = dfd.card_id
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL
  

) AS ish_prav_rf_eds_23
ON ish_prav_rf_eds_23.name = ish_prav_rf_23.name


LEFT JOIN

(

SELECT
'В Правительство РФ, Администрацию Президента РФ' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%администрация президента российской федерации (мэдо)%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  

  

) AS ish_prav_rf_vloz_23
ON ish_prav_rf_vloz_23.name = ish_prav_rf_23.name



UNION
--В федеральные органы исполнительной власти, федеральные организации

SELECT

ish_feder_23.name,
ish_feder_23."Всего отправленных",
ish_feder_23."Всего отправленных" - ish_feder_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_feder_eds_23."Подписанных УКЭП",
ish_feder_vloz_23."Имеющих вложения",
3 AS "sort"


FROM

(

SELECT
'В федеральные органы исполнительной власти, федеральные организации' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%федерация%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL


) AS ish_feder_23



LEFT JOIN

(

SELECT
'В федеральные органы исполнительной власти, федеральные организации' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%федерация%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE

) AS ish_feder_eds_23
ON ish_feder_eds_23.name = ish_feder_23.name


LEFT JOIN

(

SELECT
'В федеральные органы исполнительной власти, федеральные организации' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%федерация%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_feder_vloz_23
ON ish_feder_vloz_23.name = ish_feder_23.name



UNION
--В Аппарат Губернатора ЧО и Правительства ЧО

SELECT

ish_guber_23.name,
ish_guber_23."Всего отправленных",
ish_guber_23."Всего отправленных" - ish_guber_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_guber_eds_23."Подписанных УКЭП",
ish_guber_vloz_23."Имеющих вложения",
4 AS "sort"


FROM

(

SELECT

'В Аппарат Губернатора ЧО и Правительства ЧО' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%текслер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_guber_23



LEFT JOIN

(

SELECT

'В Аппарат Губернатора ЧО и Правительства ЧО' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%текслер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE

) AS ish_guber_eds_23
ON ish_guber_eds_23.name = ish_guber_23.name


LEFT JOIN

(

SELECT

'В Аппарат Губернатора ЧО и Правительства ЧО' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%текслер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL


) AS ish_guber_vloz_23
ON ish_guber_vloz_23.name = ish_guber_23.name




UNION
-- Заместителю Губернатора Челябинской области

SELECT

ish_zam_guber_23.name,
ish_zam_guber_23."Всего отправленных",
ish_zam_guber_23."Всего отправленных" - ish_zam_guber_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_zam_guber_eds_23."Подписанных УКЭП",
ish_zam_guber_vloz_23."Имеющих вложения",
5 AS "sort"


FROM

(

SELECT

'Заместителю Губернатора Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) IN (SELECT LOWER(su.name) FROM sec_user AS su WHERE su.position_ ILIKE '%заместитель губернатора%' AND su.delete_ts IS NULL AND su.active IS TRUE)
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_zam_guber_23



LEFT JOIN

(

SELECT

'Заместителю Губернатора Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) IN (SELECT LOWER(su.name) FROM sec_user AS su WHERE su.position_ ILIKE '%заместитель губернатора%' AND su.delete_ts IS NULL AND su.active IS TRUE)
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL

) AS ish_zam_guber_eds_23
ON ish_zam_guber_eds_23.name = ish_zam_guber_23.name


LEFT JOIN

(

SELECT

'Заместителю Губернатора Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) IN (SELECT LOWER(su.name) FROM sec_user AS su WHERE su.position_ ILIKE '%заместитель губернатора%' AND su.delete_ts IS NULL AND su.active IS TRUE)
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL


) AS ish_zam_guber_vloz_23
ON ish_zam_guber_vloz_23.name = ish_zam_guber_23.name





UNION
--Управлению Правительства Челябинской области



SELECT

ish_upr_prav_23.name,
ish_upr_prav_23."Всего отправленных",
ish_upr_prav_23."Всего отправленных" - ish_upr_prav_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_upr_prav_eds_23."Подписанных УКЭП",
ish_upr_prav_vloz_23."Имеющих вложения",
6 AS "sort"


FROM

(

SELECT
'Управлению Правительства Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL )
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  
) AS ish_upr_prav_23



LEFT JOIN

(

SELECT
'Управлению Правительства Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL )
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  

) AS ish_upr_prav_eds_23
ON ish_upr_prav_eds_23.name = ish_upr_prav_23.name


LEFT JOIN

(

SELECT
'Управлению Правительства Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL )
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL


) AS ish_upr_prav_vloz_23
ON ish_upr_prav_vloz_23.name = ish_upr_prav_23.name





UNION
--Законодательному Собранию Челябинской области


SELECT

ish_zak_sob_chel_23.name,
ish_zak_sob_chel_23."Всего отправленных",
ish_zak_sob_chel_23."Всего отправленных" - ish_zak_sob_chel_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_zak_sob_chel_eds_23."Подписанных УКЭП",
ish_zak_sob_chel_vloz_23."Имеющих вложения",
7 AS "sort"


FROM

(

SELECT
'Законодательному Собранию Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%законодательное собрание челябинской области%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

  

) AS ish_zak_sob_chel_23



LEFT JOIN

(

SELECT
'Законодательному Собранию Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%законодательное собрание челябинской области%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL

) AS ish_zak_sob_chel_eds_23
ON ish_zak_sob_chel_eds_23.name = ish_zak_sob_chel_23.name


LEFT JOIN

(

SELECT
'Законодательному Собранию Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND LOWER(dfc.name) LIKE '%законодательное собрание челябинской области%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_zak_sob_chel_vloz_23
ON ish_zak_sob_chel_vloz_23.name = ish_zak_sob_chel_23.name







UNION
--Исполнительным органам Челябинской области



SELECT

ish_isp_chel_23.name,
ish_isp_chel_23."Всего отправленных",
ish_isp_chel_23."Всего отправленных" - ish_isp_chel_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_isp_chel_eds_23."Подписанных УКЭП",
ish_isp_chel_vloz_23."Имеющих вложения",
8 AS "sort"


FROM

(

SELECT
'Исполнительным органам Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_isp_chel_23



LEFT JOIN

(

SELECT
'Исполнительным органам Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL

) AS ish_isp_chel_eds_23
ON ish_isp_chel_eds_23.name = ish_isp_chel_23.name


LEFT JOIN

(

SELECT
'Исполнительным органам Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL


) AS ish_isp_chel_vloz_23
ON ish_isp_chel_vloz_23.name = ish_isp_chel_23.name






UNION
--Исполнительным органам  субъектов Российской Федерации,  государственным организациям, органам местного самоуправления иных регионов 





SELECT

ish_isp_rf_23.name,
ish_isp_rf_23."Всего отправленных",
ish_isp_rf_23."Всего отправленных" - ish_isp_rf_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_isp_rf_eds_23."Подписанных УКЭП",
ish_isp_rf_vloz_23."Имеющих вложения",
9 AS "sort"


FROM

(

SELECT
'Исполнительным органам субъектов Российской Федерации, государственным организациям, органам местного самоуправления иных регионов' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  	
  	AND (LOWER(dfc.name) LIKE '%област%' OR LOWER(dfc.name) LIKE '%республика%' OR LOWER(dfc.name) LIKE '%округ%' OR LOWER(dfc.name) LIKE '%москва%' OR LOWER(dfc.name) LIKE '%санкт-петербург%' OR LOWER(dfc.name) LIKE '%севастополь%' OR LOWER(dfc.name) LIKE '%управлен%' OR LOWER(dfc.name) LIKE '%комитет%' OR LOWER(dfc.name) LIKE '%муниципал%')
  	AND LOWER(dfc.name) NOT LIKE '%челябинск%'
	AND LOWER(dfc.name) NOT IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.delete_ts IS NULL)



) AS ish_isp_rf_23



LEFT JOIN

(

SELECT
'Исполнительным органам субъектов Российской Федерации, государственным организациям, органам местного самоуправления иных регионов' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  	
  	AND (LOWER(dfc.name) LIKE '%област%' OR LOWER(dfc.name) LIKE '%республика%' OR LOWER(dfc.name) LIKE '%округ%' OR LOWER(dfc.name) LIKE '%москва%' OR LOWER(dfc.name) LIKE '%санкт-петербург%' OR LOWER(dfc.name) LIKE '%севастополь%' OR LOWER(dfc.name) LIKE '%управлен%' OR LOWER(dfc.name) LIKE '%комитет%' OR LOWER(dfc.name) LIKE '%муниципал%')
  	AND LOWER(dfc.name) NOT LIKE '%челябинск%'
	AND LOWER(dfc.name) NOT IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.delete_ts IS NULL)
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL



	
) AS ish_isp_rf_eds_23
ON ish_isp_rf_eds_23.name = ish_isp_rf_23.name


LEFT JOIN

(

SELECT
'Исполнительным органам субъектов Российской Федерации, государственным организациям, органам местного самоуправления иных регионов' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  	
  	AND (LOWER(dfc.name) LIKE '%област%' OR LOWER(dfc.name) LIKE '%республика%' OR LOWER(dfc.name) LIKE '%округ%' OR LOWER(dfc.name) LIKE '%москва%' OR LOWER(dfc.name) LIKE '%санкт-петербург%' OR LOWER(dfc.name) LIKE '%севастополь%' OR LOWER(dfc.name) LIKE '%управлен%' OR LOWER(dfc.name) LIKE '%комитет%' OR LOWER(dfc.name) LIKE '%муниципал%')
  	AND LOWER(dfc.name) NOT LIKE '%челябинск%'
	AND LOWER(dfc.name) NOT IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.delete_ts IS NULL)



) AS ish_isp_rf_vloz_23
ON ish_isp_rf_vloz_23.name = ish_isp_rf_23.name






UNION
--Подведомственных организаций






SELECT

ish_podved_io_23.name,
ish_podved_io_23."Всего отправленных",
ish_podved_io_23."Всего отправленных" - ish_podved_io_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_podved_io_eds_23."Подписанных УКЭП",
ish_podved_io_vloz_23."Имеющих вложения",
10 AS "sort"


FROM

(

SELECT
'Подведомственных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_podved_io_23



LEFT JOIN

(

SELECT
'Подведомственных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  

) AS ish_podved_io_eds_23
ON ish_podved_io_eds_23.name = ish_podved_io_23.name


LEFT JOIN

(

SELECT
'Подведомственных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_podved_io_vloz_23
ON ish_podved_io_vloz_23.name = ish_podved_io_23.name







UNION
--Органам местного самоуправления Челябинской области



SELECT

ish_omsu_23.name,
ish_omsu_23."Всего отправленных",
ish_omsu_23."Всего отправленных" - ish_omsu_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_omsu_eds_23."Подписанных УКЭП",
ish_omsu_vloz_23."Имеющих вложения",
11 AS "sort"


FROM

(

SELECT
'Органам местного самоуправления Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_omsu_23



LEFT JOIN

(

SELECT
'Органам местного самоуправления Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  


) AS ish_omsu_eds_23
ON ish_omsu_eds_23.name = ish_omsu_23.name


LEFT JOIN

(

SELECT
'Органам местного самоуправления Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_omsu_vloz_23
ON ish_omsu_vloz_23.name = ish_omsu_23.name






UNION
--Отраслевым органам местного самоуправления,  муниципальным организациям



SELECT

ish_pod_omsu_23.name,
ish_pod_omsu_23."Всего отправленных",
ish_pod_omsu_23."Всего отправленных" - ish_pod_omsu_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_pod_omsu_eds_23."Подписанных УКЭП",
ish_pod_omsu_vloz_23."Имеющих вложения",
12 AS "sort"


FROM

(

SELECT
'Отраслевым органам местного самоуправления,  муниципальным организациям' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_pod_omsu_23



LEFT JOIN

(

SELECT
'Отраслевым органам местного самоуправления,  муниципальным организациям' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  


) AS ish_pod_omsu_eds_23
ON ish_pod_omsu_eds_23.name = ish_pod_omsu_23.name


LEFT JOIN

(

SELECT
'Отраслевым органам местного самоуправления,  муниципальным организациям' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id AND dfc.delete_ts IS NULL
JOIN gov74_doc_addressee AS gda ON gda.doc_office_data_id = dfdod.id AND gda.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gda.correspondent_id AND dfc2.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc2.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       
       AND su.id IN (SELECT su2.id FROM sec_user AS su2 WHERE su2.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL) AND su2.delete_ts IS NULL)
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_pod_omsu_vloz_23
ON ish_pod_omsu_vloz_23.name = ish_pod_omsu_23.name





UNION
--13. Иным организациям

SELECT

'Иным организациям' AS name,
0 AS "Всего отправленных",
0 AS "Не подписанных УКЭП",
0 AS "Подписанных УКЭП",
0 AS "Имеющих вложения",
13 AS "sort"


UNION
--14. Гражданам

SELECT

'Гражданам (ответ на обращения, запросы)' AS name,
0 AS "Всего отправленных",
0 AS "Не подписанных УКЭП",
0 AS "Подписанных УКЭП",
0 AS "Имеющих вложения",
14 AS "sort"




UNION
--15. Всего


SELECT

ish_vsego_23.name,
ish_vsego_23."Всего отправленных",
ish_vsego_23."Всего отправленных" - ish_vsego_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
ish_vsego_eds_23."Подписанных УКЭП",
ish_vsego_vloz_23."Имеющих вложения",
15 AS "sort"


FROM

(

SELECT
'Всего' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS ish_vsego_23



LEFT JOIN

(

SELECT
'Всего' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.card_id = dfd.card_id
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL
  

) AS ish_vsego_eds_23
ON ish_vsego_eds_23.name = ish_vsego_23.name


LEFT JOIN

(

SELECT
'Всего' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN DF_DOC_OFFICE_DATA_ADDRESSEE dfdoda ON dfdod.id = dfdoda.doc_office_data_id AND dfdoda.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON dfdoda.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '208fc587-2098-595d-09ec-7c1cba4ae9c1'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  

) AS ish_vsego_vloz_23
ON ish_vsego_vloz_23.name = ish_vsego_23.name


ORDER BY sort ASC