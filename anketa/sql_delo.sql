-- Количество дел
-- На момент написания, в системе не было разделение на "до 10 лет" и "более 10 лет", поэтому они по нулям
-- Далее просто считаем общее количество документов во всех делах и объём в МБ


SELECT
'До 10 лет (включительно)' AS "name",
0 AS "Документов",
0 AS "Дел",
0 AS "Обьем",
1 AS "sort"

UNION


SELECT
'Временных (свыше 10 лет) сроков хранения' AS "name",
0 AS "Документов",
0 AS "Дел",
0 AS "Обьем",
2 AS "sort"

UNION


SELECT

delo_docs_23.name,
delo_docs_23."Документов",
delo_kolvo_23."Дел",
delo_size_23."Обьем",
3 AS "sort"


FROM

(

SELECT
'Постоянного срока хранения' AS NAME,
COUNT(DISTINCT(dfd.card_id)) AS "Документов"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
) AS delo_docs_23



LEFT JOIN

(

SELECT

'Постоянного срока хранения' AS NAME,
COUNT(*) AS "Дел"

FROM df_office_file AS dfof 
WHERE
	dfof.organization_id = :org_id
	AND dfof.displayed_name LIKE '%2023%'
  
) AS delo_kolvo_23
ON delo_kolvo_23.name = delo_docs_23.name



LEFT JOIN


(

SELECT
'Постоянного срока хранения' AS NAME,
COUNT(DISTINCT(sf.id)) AS "Всего файлов",
ROUND(SUM(sf.file_size) / 1024 / 1024) AS "Объем"
FROM DF_SIMPLE_DOC dfsd
JOIN df_doc dfd ON dfsd.card_id = dfd.card_id
LEFT OUTER JOIN DF_DOC_OFFICE_DATA dfdod ON dfd.card_id = dfdod.doc_id AND dfdod.delete_ts IS NULL
JOIN wf_card wfc ON dfd.card_id = wfc.id AND wfc.delete_ts IS NULL
JOIN wf_attachment AS wfa ON wfa.card_id = dfd.card_id AND wfa.delete_ts IS NULL
JOIN sys_file AS sf ON sf.id = wfa.file_id AND sf.delete_ts IS NULL
WHERE (dfd.is_template = 'f'
       AND dfd.version_of_id IS NULL
       AND dfd.archived = 'f'
       AND (CAST('a4ab128a-25bf-8da8-74ed-c5773fb05371' AS VARCHAR) = CAST('a7832ba1-0000-8329-f8dc-8284c103ad8e' AS VARCHAR)
            AND dfd.registered = 'f'
            OR dfdod.reg_year = 'a4ab128a-25bf-8da8-74ed-c5773fb05371')
       AND dfd.organization_id = :org_id
       AND wfc.delete_ts IS NULL)
  AND wfc.card_type = '1115'
  
) AS delo_size_23
ON delo_size_23.name = delo_docs_23.name

ORDER BY sort ASC

