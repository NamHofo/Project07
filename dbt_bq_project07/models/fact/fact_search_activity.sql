{{ config(materialized='table') }}

WITH search_data AS (
  SELECT
    time_stamp,
    local_time,
    user_id_db,
    key_search,
    COUNT(*) AS search_count
  FROM {{ source('summary_your_dataset', 'change_data_type') }}
  WHERE key_search IS NOT NULL
  GROUP BY time_stamp, local_time, user_id_db, key_search
)

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(user_id_db AS STRING), key_search)) AS STRING) AS fact_id,
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS time_id,
  user_id_db,
  key_search,
  search_count
FROM search_data