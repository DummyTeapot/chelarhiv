-- :org_id заменяется с помощью php PDO на id организации пользователя, который делает запрос
-- Сам id берётся из php сессии после авторизации в генераторе отчётов
-- Запросы состовлялись из требований бизнес-аналитиков



SELECT

vn_npa_23.name,
vn_npa_23."Всего внутренних",
vn_npa_23."Всего внутренних" - vn_npa_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vn_npa_eds_23."Подписанных УКЭП",
vn_npa_vloz_23."Имеющих вложения",
1 AS "sort"


FROM

(

SELECT
'НПА' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего внутренних"
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
       AND sc.id = 'e73811f6-7356-4d6b-9268-830d6e59f251'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'

  

) AS vn_npa_23



LEFT JOIN

(

SELECT
'НПА' AS "name",
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
       AND sc.id = 'e73811f6-7356-4d6b-9268-830d6e59f251'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE

) AS vn_npa_eds_23
ON vn_npa_eds_23.name = vn_npa_23.name


LEFT JOIN

(

SELECT
'НПА' AS "name",
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
       AND sc.id = 'e73811f6-7356-4d6b-9268-830d6e59f251'
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'


) AS vn_npa_vloz_23
ON vn_npa_vloz_23.name = vn_npa_23.name






UNION
--Служебные записки





SELECT

vn_sluz_23.name,
vn_sluz_23."Всего внутренних",
vn_sluz_23."Всего внутренних" - vn_sluz_eds_23."Подписанных УКЭП" AS "Не подписанных УКЭП",
vn_sluz_eds_23."Подписанных УКЭП",
vn_sluz_vloz_23."Имеющих вложения",
2 AS "sort"


FROM

(

SELECT
'Служебные записки' AS "name",
COUNT(DISTINCT(dfd.card_id)) AS "Всего внутренних"
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
       AND sc.id = '24e40c08-fe87-11e2-8c8a-3354b77dcb1f'
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'

  

) AS vn_sluz_23



LEFT JOIN

(

SELECT
'Служебные записки' AS "name",
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
       AND sc.id = '24e40c08-fe87-11e2-8c8a-3354b77dcb1f'
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
  --ПРОВЕРКА НА ПОДПИСЬ
  AND wfa.signatures IS NOT NULL
  AND wfa."sign" IS TRUE

) AS vn_sluz_eds_23
ON vn_sluz_eds_23.name = vn_sluz_23.name


LEFT JOIN

(

SELECT
'Служебные записки' AS "name",
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
       AND sc.id = '24e40c08-fe87-11e2-8c8a-3354b77dcb1f'
       
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'


) AS vn_sluz_vloz_23
ON vn_sluz_vloz_23.name = vn_sluz_23.name






UNION
--Служебные записки





SELECT

vn_tmt_23.name,
vn_tmt_23."Всего внутренних",
vn_tmt_23."Всего внутренних" AS "Не подписанных УКЭП",
0 AS "Подписанных УКЭП",
vn_tmt_vloz_23."Имеющих вложения",
3 AS "sort"


FROM

(

SELECT 'Поручения' AS "name",
COUNT(DISTINCT(tmt.card_id)) AS "Всего внутренних"
FROM TM_TASK tmt
JOIN wf_card wfc ON tmt.card_id = wfc.id AND wfc.delete_ts IS NULL
WHERE (wfc.state IS NOT NULL
       AND tmt.organization_id = :org_id
       AND tmt.create_date >= '2023-01-01'
       AND tmt.create_date <= '2023-12-31'
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '35'

) AS vn_tmt_23


LEFT JOIN

(

SELECT 'Поручения' AS "name",
COUNT(DISTINCT(tmt.card_id)) AS "Имеющих вложения"
FROM TM_TASK tmt
JOIN wf_card wfc ON tmt.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = tmt.card_id AND wfa.delete_ts IS NULL
WHERE (wfc.state IS NOT NULL
       AND tmt.organization_id = :org_id
       AND tmt.create_date >= '2023-01-01'
       AND tmt.create_date <= '2023-12-31'
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '35'

) AS vn_tmt_vloz_23
ON vn_tmt_vloz_23.name = vn_tmt_23.name


ORDER BY sort ASC