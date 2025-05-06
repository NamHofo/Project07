{{ config(materialized='table') }}

WITH click_data AS (
  SELECT
    time_stamp,
    local_time,
    user_id_db,
    CAST(FARM_FINGERPRINT(CONCAT(recommendation, CAST(recommendation_product_id AS STRING))) AS STRING) AS recommendation_id,
    COUNT(*) AS click_count
  FROM {{ source('summary_your_dataset', 'change_data_type') }}
  WHERE recommendation_clicked_position IS NOT NULL
  GROUP BY time_stamp, local_time, user_id_db, recommendation, recommendation_product_id
)

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(user_id_db AS STRING), recommendation_id)) AS STRING) AS fact_id,
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS time_id,
  user_id_db,
  recommendation_id,
  click_count
FROM click_data