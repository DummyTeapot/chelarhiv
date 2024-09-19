-- :org_id заменяется с помощью php PDO на id организации пользователя, который делает запрос
-- Сам id берётся из php сессии после авторизации в генераторе отчётов
-- Запросы состовлялись из требований бизнес-аналитиков



SELECT

vh_sov_fed_23.name,
vh_sov_fed_23."Всего отправленных",
vh_sov_fed_23."Всего отправленных" - vh_sov_fed_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_sov_fed_eds_23."Подписанных УКЭП",
vh_sov_fed_vloz_23."Имеющих вложения",
1 AS "sort"

FROM

(

SELECT
'Запросов членов Совета Федерации, депутатов Государственной Думы' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfc.name) LIKE '%совет федер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL

  

) AS vh_sov_fed_23



LEFT JOIN

(

SELECT
'Запросов членов Совета Федерации, депутатов Государственной Думы' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfc.name) LIKE '%совет федер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL

) AS vh_sov_fed_eds_23
ON vh_sov_fed_eds_23.name = vh_sov_fed_23.name


LEFT JOIN

(

SELECT
'Запросов членов Совета Федерации, депутатов Государственной Думы' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfc.name) LIKE '%совет федер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL

) AS vh_sov_fed_vloz_23
ON vh_sov_fed_vloz_23.name = vh_sov_fed_23.name




UNION
--Правительство РФ, Администрация Президента РФ


SELECT

vh_prav_rf_23.name,
vh_prav_rf_23."Всего отправленных",
vh_prav_rf_23."Всего отправленных" - vh_prav_rf_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_prav_rf_eds_23."Подписанных УКЭП",
vh_prav_rf_vloz_23."Имеющих вложения",
2 AS "sort"


FROM

(

SELECT
'Правительство РФ, Администрация Президента РФ' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND LOWER(dfc.name) LIKE 'администрация президента российской федерации (мэдо)'
       AND dfd.organization_id = :org_id
       AND wfc.id IN
         (SELECT wfc2.id
          FROM GOV74_DOC_RECEIVING_METHOD gdrm
          JOIN DF_DOC_OFFICE_DATA dfdod2 ON gdrm.gov74_doc_office_data_id = dfdod2.id
          JOIN df_doc dfd2 ON dfdod2.doc_id = dfd2.card_id
          JOIN wf_card wfc2 ON dfd2.card_id = wfc2.id
          WHERE (gdrm.doc_receiving_method_id = '9951ec35-84a3-96a0-2d48-f9fe7a6f113c')
            AND gdrm.delete_ts IS NULL)
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL

) AS vh_prav_rf_23



LEFT JOIN

(

SELECT
'Правительство РФ, Администрация Президента РФ' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND LOWER(dfc.name) LIKE 'администрация президента российской федерации (мэдо)'
       AND dfd.organization_id = :org_id
       AND wfc.id IN
         (SELECT wfc2.id
          FROM GOV74_DOC_RECEIVING_METHOD gdrm
          JOIN DF_DOC_OFFICE_DATA dfdod2 ON gdrm.gov74_doc_office_data_id = dfdod2.id
          JOIN df_doc dfd2 ON dfdod2.doc_id = dfd2.card_id
          JOIN wf_card wfc2 ON dfd2.card_id = wfc2.id
          WHERE (gdrm.doc_receiving_method_id = '9951ec35-84a3-96a0-2d48-f9fe7a6f113c')
            AND gdrm.delete_ts IS NULL)
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.card_id = dfd.card_id
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL
  

) AS vh_prav_rf_eds_23
ON vh_prav_rf_eds_23.name = vh_prav_rf_23.name


LEFT JOIN

(

SELECT
'Правительство РФ, Администрация Президента РФ' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND LOWER(dfc.name) LIKE 'администрация президента российской федерации (мэдо)'
       AND dfd.organization_id = :org_id
       AND wfc.id IN
         (SELECT wfc2.id
          FROM GOV74_DOC_RECEIVING_METHOD gdrm
          JOIN DF_DOC_OFFICE_DATA dfdod2 ON gdrm.gov74_doc_office_data_id = dfdod2.id
          JOIN df_doc dfd2 ON dfdod2.doc_id = dfd2.card_id
          JOIN wf_card wfc2 ON dfd2.card_id = wfc2.id
          WHERE (gdrm.doc_receiving_method_id = '9951ec35-84a3-96a0-2d48-f9fe7a6f113c')
            AND gdrm.delete_ts IS NULL)
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  AND dfdod.delete_ts IS NULL
  

  

) AS vh_prav_rf_vloz_23
ON vh_prav_rf_vloz_23.name = vh_prav_rf_23.name



UNION
--Из федеральных органов исполнительной власти, федеральных организаций

SELECT

vh_feder_23.name,
vh_feder_23."Всего отправленных",
vh_feder_23."Всего отправленных" - vh_feder_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_feder_eds_23."Подписанных УКЭП",
vh_feder_vloz_23."Имеющих вложения",
3 AS "sort"


FROM

(

SELECT
'Из федеральных органов исполнительной власти, федеральных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfc.name) LIKE '%федерация%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  --AND wfa.signatures IS NOT NULL

) AS vh_feder_23



LEFT JOIN

(

SELECT
'Из федеральных органов исполнительной власти, федеральных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfc.name) LIKE '%федерация%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL

) AS vh_feder_eds_23
ON vh_feder_eds_23.name = vh_feder_23.name


LEFT JOIN

(

SELECT
'Из федеральных органов исполнительной власти, федеральных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfc.name) LIKE '%федерация%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL

) AS vh_feder_vloz_23
ON vh_feder_vloz_23.name = vh_feder_23.name



UNION
--Аппарата Губернатора ЧО и Правительства ЧО

SELECT

vh_guber_23.name,
vh_guber_23."Всего отправленных",
vh_guber_23."Всего отправленных" - vh_guber_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_guber_eds_23."Подписанных УКЭП",
vh_guber_vloz_23."Имеющих вложения",
4 AS "sort"


FROM

(

SELECT

'Аппарата Губернатора ЧО и Правительства ЧО' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod2 ON dfd.card_id = dfdod2.doc_id
AND dfdod2.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod2.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfdod.doc_sender) LIKE '%текслер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfdod.delete_ts IS NULL

) AS vh_guber_23



LEFT JOIN

(

SELECT

'Аппарата Губернатора ЧО и Правительства ЧО' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod2 ON dfd.card_id = dfdod2.doc_id
AND dfdod2.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod2.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfdod.doc_sender) LIKE '%текслер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfdod.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL

) AS vh_guber_eds_23
ON vh_guber_eds_23.name = vh_guber_23.name


LEFT JOIN

(

SELECT

'Аппарата Губернатора ЧО и Правительства ЧО' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod2 ON dfd.card_id = dfdod2.doc_id
AND dfdod2.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod2.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfdod.doc_sender) LIKE '%текслер%'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfdod.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL


) AS vh_guber_vloz_23
ON vh_guber_vloz_23.name = vh_guber_23.name




UNION
-- От заместителей Губернатора Челябинской области

SELECT

vh_zam_guber_23.name,
vh_zam_guber_23."Всего отправленных",
vh_zam_guber_23."Всего отправленных" - vh_zam_guber_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_zam_guber_eds_23."Подписанных УКЭП",
vh_zam_guber_vloz_23."Имеющих вложения",
5 AS "sort"


FROM

(

SELECT

'От заместителей Губернатора Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod2 ON dfd.card_id = dfdod2.doc_id
AND dfdod2.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod2.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfdod.doc_sender) IN (SELECT LOWER(su.name) FROM sec_user AS su WHERE su.position_ ILIKE '%заместитель губернатора%' AND su.delete_ts IS NULL AND su.active IS TRUE)
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfdod.delete_ts IS NULL

) AS vh_zam_guber_23



LEFT JOIN

(

SELECT

'От заместителей Губернатора Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod2 ON dfd.card_id = dfdod2.doc_id
AND dfdod2.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod2.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfdod.doc_sender) IN (SELECT LOWER(su.name) FROM sec_user AS su WHERE su.position_ ILIKE '%заместитель губернатора%' AND su.delete_ts IS NULL AND su.active IS TRUE)
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfdod.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL

) AS vh_zam_guber_eds_23
ON vh_zam_guber_eds_23.name = vh_zam_guber_23.name


LEFT JOIN

(

SELECT

'От заместителей Губернатора Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod2 ON dfd.card_id = dfdod2.doc_id
AND dfdod2.delete_ts IS NULL
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod2.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND LOWER(dfdod.doc_sender) IN (SELECT LOWER(su.name) FROM sec_user AS su WHERE su.position_ ILIKE '%заместитель губернатора%' AND su.delete_ts IS NULL AND su.active IS TRUE)
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfdod.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL


) AS vh_zam_guber_vloz_23
ON vh_zam_guber_vloz_23.name = vh_zam_guber_23.name






UNION
--Из управлений Правительства Челябинской области






SELECT

vh_upr_prav_23.name,
vh_upr_prav_23."Всего отправленных",
vh_upr_prav_23."Всего отправленных" - vh_upr_prav_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_upr_prav_eds_23."Подписанных УКЭП",
vh_upr_prav_vloz_23."Имеющих вложения",
6 AS "sort"


FROM

(

SELECT
'Из управлений Правительства Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  	
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
	)

) AS vh_upr_prav_23



LEFT JOIN

(

SELECT
'Из управлений Правительства Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
	)

) AS vh_upr_prav_eds_23
ON vh_upr_prav_eds_23.name = vh_upr_prav_23.name


LEFT JOIN

(

SELECT
'Из управлений Правительства Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND wfa.delete_ts IS NULL
  
    AND dfc.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
    
    AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.parent_organization_id = 'a84e4780-0f90-c639-bb14-e2ce58f05733' AND dfo.delete_ts IS NULL)
	)


) AS vh_upr_prav_vloz_23
ON vh_upr_prav_vloz_23.name = vh_upr_prav_23.name





UNION
--Из Законодательного Собрания Челябинской области


SELECT

vh_zak_sob_chel_23.name,
vh_zak_sob_chel_23."Всего отправленных",
vh_zak_sob_chel_23."Всего отправленных" - vh_zak_sob_chel_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_zak_sob_chel_eds_23."Подписанных УКЭП",
vh_zak_sob_chel_vloz_23."Имеющих вложения",
7 AS "sort"


FROM

(

SELECT
'Из Законодательного Собрания Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN df_correspondent AS dfc2 ON gdc.correspondent_sender_id = dfc2.id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       
       AND( 
		 	LOWER(dfc.name) LIKE '%законодательное собрание челябинской области%'
		 	OR
		 	LOWER(dfc2.name) LIKE '%законодательное собрание челябинской области%'
       )
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL

  

) AS vh_zak_sob_chel_23



LEFT JOIN

(

SELECT
'Из Законодательного Собрания Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN df_correspondent AS dfc2 ON gdc.correspondent_sender_id = dfc2.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       
       AND( 
		 	LOWER(dfc.name) LIKE '%законодательное собрание челябинской области%'
		 	OR
		 	LOWER(dfc2.name) LIKE '%законодательное собрание челябинской области%'
       )
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL

) AS vh_zak_sob_chel_eds_23
ON vh_zak_sob_chel_eds_23.name = vh_zak_sob_chel_23.name


LEFT JOIN

(

SELECT
'Из Законодательного Собрания Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN GOV_DOC_CORRESPONDENT gdc ON dfdod.id = gdc.doc_office_data_id AND gdc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN DF_CORRESPONDENT dfc ON gdc.correspondent_id = dfc.id
JOIN df_correspondent AS dfc2 ON gdc.correspondent_sender_id = dfc2.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       
       AND( 
		 	LOWER(dfc.name) LIKE '%законодательное собрание челябинской области%'
		 	OR
		 	LOWER(dfc2.name) LIKE '%законодательное собрание челябинской области%'
       )
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND dfc.delete_ts IS NULL
  
  AND wfa.delete_ts IS NULL

) AS vh_zak_sob_chel_vloz_23
ON vh_zak_sob_chel_vloz_23.name = vh_zak_sob_chel_23.name







UNION
--Из исполнительных органов Челябинской области



SELECT

vh_isp_chel_23.name,
vh_isp_chel_23."Всего отправленных",
vh_isp_chel_23."Всего отправленных" - vh_isp_chel_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_isp_chel_eds_23."Подписанных УКЭП",
vh_isp_chel_vloz_23."Имеющих вложения",
8 AS "sort"


FROM

(

SELECT
'Из исполнительных органов Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  	
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL)
	)

) AS vh_isp_chel_23



LEFT JOIN

(

SELECT
'Из исполнительных органов Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL)
	)

) AS vh_isp_chel_eds_23
ON vh_isp_chel_eds_23.name = vh_isp_chel_23.name


LEFT JOIN

(

SELECT
'Из исполнительных органов Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND wfa.delete_ts IS NULL
  

    AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = '4e7ae7f9-63a1-458d-8a2b-31555897cb9d' AND dfo.delete_ts IS NULL)
	)


) AS vh_isp_chel_vloz_23
ON vh_isp_chel_vloz_23.name = vh_isp_chel_23.name






UNION
--Из исполнительных органов субъектов Российской Федерации,  госутрственных организаций, органов местного самоуправления иных регионов 





SELECT

vh_isp_rf_23.name,
vh_isp_rf_23."Всего отправленных",
vh_isp_rf_23."Всего отправленных" - vh_isp_rf_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_isp_rf_eds_23."Подписанных УКЭП",
vh_isp_rf_vloz_23."Имеющих вложения",
9 AS "sort"


FROM

(

SELECT
'Из исполнительных органов субъектов Российской Федерации,  госутрственных организаций, органов местного самоуправления иных регионов' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id
--внешний корреспондент
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  	
  	AND (LOWER(dfc.name) LIKE '%област%' OR LOWER(dfc.name) LIKE '%республика%' OR LOWER(dfc.name) LIKE '%округ%' OR LOWER(dfc.name) LIKE '%москва%' OR LOWER(dfc.name) LIKE '%санкт-петербург%' OR LOWER(dfc.name) LIKE '%севастополь%' OR LOWER(dfc.name) LIKE '%управлен%' OR LOWER(dfc.name) LIKE '%комитет%' OR LOWER(dfc.name) LIKE '%муниципал%')
  	AND LOWER(dfc.name) NOT LIKE '%челябинск%'
	AND LOWER(dfc.name) NOT IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.delete_ts IS NULL)



) AS vh_isp_rf_23



LEFT JOIN

(

SELECT
'Из исполнительных органов субъектов Российской Федерации,  госутрственных организаций, органов местного самоуправления иных регионов' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id
--внешний корреспондент
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  
  	AND (LOWER(dfc.name) LIKE '%област%' OR LOWER(dfc.name) LIKE '%республика%' OR LOWER(dfc.name) LIKE '%округ%' OR LOWER(dfc.name) LIKE '%москва%' OR LOWER(dfc.name) LIKE '%санкт-петербург%' OR LOWER(dfc.name) LIKE '%севастополь%' OR LOWER(dfc.name) LIKE '%управлен%' OR LOWER(dfc.name) LIKE '%комитет%' OR LOWER(dfc.name) LIKE '%муниципал%')
  	AND LOWER(dfc.name) NOT LIKE '%челябинск%'
	AND LOWER(dfc.name) NOT IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.delete_ts IS NULL)


	
) AS vh_isp_rf_eds_23
ON vh_isp_rf_eds_23.name = vh_isp_rf_23.name


LEFT JOIN

(

SELECT
'Из исполнительных органов субъектов Российской Федерации,  госутрственных организаций, органов местного самоуправления иных регионов' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id
AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id
JOIN wf_card wfc ON dfd.card_id = wfc.id
JOIN sys_category sc ON dfdk.category_id = sc.id
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id
--внешний корреспондент
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  AND wfa.delete_ts IS NULL
  
  	AND (LOWER(dfc.name) LIKE '%област%' OR LOWER(dfc.name) LIKE '%республика%' OR LOWER(dfc.name) LIKE '%округ%' OR LOWER(dfc.name) LIKE '%москва%' OR LOWER(dfc.name) LIKE '%санкт-петербург%' OR LOWER(dfc.name) LIKE '%севастополь%' OR LOWER(dfc.name) LIKE '%управлен%' OR LOWER(dfc.name) LIKE '%комитет%' OR LOWER(dfc.name) LIKE '%муниципал%')
  	AND LOWER(dfc.name) NOT LIKE '%челябинск%'
	AND LOWER(dfc.name) NOT IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.delete_ts IS NULL)



) AS vh_isp_rf_vloz_23
ON vh_isp_rf_vloz_23.name = vh_isp_rf_23.name






UNION
--Из подведомственных организаций






SELECT

vh_podved_io_23.name,
vh_podved_io_23."Всего отправленных",
vh_podved_io_23."Всего отправленных" - vh_podved_io_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_podved_io_eds_23."Подписанных УКЭП",
vh_podved_io_vloz_23."Имеющих вложения",
10 AS "sort"


FROM

(

SELECT
'Из подведомственных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  	
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL)
	)

) AS vh_podved_io_23



LEFT JOIN

(

SELECT
'Из подведомственных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL)
	)

) AS vh_podved_io_eds_23
ON vh_podved_io_eds_23.name = vh_podved_io_23.name


LEFT JOIN

(

SELECT
'Из подведомственных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  AND wfa.delete_ts IS NULL

	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = 'd6d0fda0-e030-0b8c-b8c3-5fb0ca81510d' AND dfo.delete_ts IS NULL)
	)

) AS vh_podved_io_vloz_23
ON vh_podved_io_vloz_23.name = vh_podved_io_23.name







UNION
--Из органов местного самоуправления Челябинской области



SELECT

vh_omsu_23.name,
vh_omsu_23."Всего отправленных",
vh_omsu_23."Всего отправленных" - vh_omsu_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_omsu_eds_23."Подписанных УКЭП",
vh_omsu_vloz_23."Имеющих вложения",
11 AS "sort"


FROM

(

SELECT
'Из органов местного самоуправления Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  	
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL)
	)

) AS vh_omsu_23



LEFT JOIN

(

SELECT
'Из органов местного самоуправления Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  

    AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL)
	)

) AS vh_omsu_eds_23
ON vh_omsu_eds_23.name = vh_omsu_23.name


LEFT JOIN

(

SELECT
'Из органов местного самоуправления Челябинской области' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  AND wfa.delete_ts IS NULL
  
    AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = 'c6fefae3-6c60-4855-9d89-e5bf2ae7c33e' AND dfo.delete_ts IS NULL)
	)

) AS vh_omsu_vloz_23
ON vh_omsu_vloz_23.name = vh_omsu_23.name






UNION
--Из отраслевых органов местного самоуправления, муниципальных организаций



SELECT

vh_pod_omsu_23.name,
vh_pod_omsu_23."Всего отправленных",
vh_pod_omsu_23."Всего отправленных" - vh_pod_omsu_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_pod_omsu_eds_23."Подписанных УКЭП",
vh_pod_omsu_vloz_23."Имеющих вложения",
12 AS "sort"


FROM

(

SELECT
'Из отраслевых органов местного самоуправления, муниципальных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL

WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  	
	AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL)
	)

) AS vh_pod_omsu_23



LEFT JOIN

(

SELECT
'Из отраслевых органов местного самоуправления, муниципальных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE
  AND wfa.delete_ts IS NULL
  

    AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL)
	)

) AS vh_pod_omsu_eds_23
ON vh_pod_omsu_eds_23.name = vh_pod_omsu_23.name


LEFT JOIN

(

SELECT
'Из отраслевых органов местного самоуправления, муниципальных организаций' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN gov_doc_correspondent AS gdc ON gdc.doc_office_data_id = dfdod.id AND gdc.delete_ts IS NULL
JOIN df_correspondent AS dfc ON dfc.id = gdc.correspondent_sender_id AND dfc.delete_ts IS NULL
JOIN df_employee AS dfe ON dfe.correspondent_id = dfc.id
JOIN sec_user AS su ON su.id = dfe.user_id AND su.delete_ts IS NULL
JOIN df_correspondent AS dfc2 ON dfc2.id = gdc.correspondent_id AND dfc2.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  AND wfa.delete_ts IS NULL
  
    AND
	 ( 
	 	su.organization_id IN (SELECT dfo.id FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL)
		OR LOWER(dfc2.name) IN (SELECT LOWER(dfo.name) FROM df_organization AS dfo WHERE dfo.organization_type_id = '85dac2ec-1302-5823-dec2-3e0dd6910351' AND dfo.delete_ts IS NULL)
	)

) AS vh_pod_omsu_vloz_23
ON vh_pod_omsu_vloz_23.name = vh_pod_omsu_23.name




UNION
--13. Из иных организаций

SELECT

'Из иных организаций' AS name,
0 AS "Всего отправленных",
0 AS "Не подписанных УКЭП",
0 AS "Подписанных УКЭП",
0 AS "Имеющих вложения",
13 AS "sort"


UNION
--14. Гражданам

SELECT

'От граждан (обращения, запросы)' AS name,
0 AS "Всего отправленных",
0 AS "Не подписанных УКЭП",
0 AS "Подписанных УКЭП",
0 AS "Имеющих вложения",
14 AS "sort"




UNION
--15. Всего


SELECT

vh_vsego_23.name,
vh_vsego_23."Всего отправленных",
vh_vsego_23."Всего отправленных" - vh_vsego_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vh_vsego_eds_23."Подписанных УКЭП",
vh_vsego_vloz_23."Имеющих вложения",
15 AS "sort"


FROM

(

SELECT
'Всего' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего отправленных"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'

) AS vh_vsego_23



LEFT JOIN

(

SELECT
'Всего' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Подписанных УКЭП"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.card_id = dfd.card_id
  AND wfa."sign" IS TRUE
  AND wfa.signatures IS NOT NULL
  

) AS vh_vsego_eds_23
ON vh_vsego_eds_23.name = vh_vsego_23.name


LEFT JOIN

(

SELECT
'Всего' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Имеющих вложения"

FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN df_doc_kind dfdk ON dfd.doc_kind_id = dfdk.category_id AND dfdk.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN sys_category sc ON dfdk.category_id = sc.id AND sc.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND sc.id = '830a2b7d-3aa1-a01f-554d-cad3a6e16a1e'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  

  

) AS vh_vsego_vloz_23
ON vh_vsego_vloz_23.name = vh_vsego_23.name



ORDER BY "sort" ASC