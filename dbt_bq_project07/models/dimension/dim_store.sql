{{ config(materialized='table',) }}

SELECT  
    store_id
FROM
    {{ ref('stg_change_data_type') }}
WHERE
    store_id IS NOT NULL

