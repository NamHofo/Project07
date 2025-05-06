{{ config(materialized='table') }}

WITH view_data AS (
  SELECT
    time_stamp,
    local_time,
    user_id_db,
    viewing_product_id AS product_id,
    store_id,
    COUNT(*) AS view_count
  FROM {{ source('summary_your_dataset', 'change_data_type') }}
  WHERE viewing_product_id IS NOT NULL
  GROUP BY time_stamp, local_time, user_id_db, viewing_product_id, store_id
)

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(user_id_db AS STRING), CAST(product_id AS STRING))) AS STRING) AS fact_id,
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS time_id,
  user_id_db,
  product_id,
  store_id,
  view_count
FROM view_data