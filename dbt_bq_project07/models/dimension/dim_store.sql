{{ config(materialized='table',) }}

SELECT  
    store_id,
    CONCAT('Store ', CAST(store_id AS STRING)) AS store_name
FROM
    {{ ref('stg_change_data_type') }}
WHERE
    store_id IS NOT NULL
GROUP BY 
    store_id,
    store_name

