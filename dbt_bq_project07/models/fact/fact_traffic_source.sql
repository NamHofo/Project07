{{ config(materialized='table') }}

WITH traffic_data AS (
  SELECT
    time_stamp,
    local_time,
    user_id_db,
    CAST(FARM_FINGERPRINT(CONCAT(utm_source, utm_medium, current_url, referrer_url)) AS STRING) AS marketing_id,
    COUNT(*) AS visit_count
  FROM {{ source('summary_your_dataset', 'change_data_type') }}
  WHERE utm_source IS NOT NULL
  GROUP BY time_stamp, local_time, user_id_db, utm_source, utm_medium, current_url, referrer_url
)

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(user_id_db AS STRING), marketing_id)) AS STRING) AS fact_id,
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS time_id,
  user_id_db,
  marketing_id,
  visit_count
FROM traffic_data