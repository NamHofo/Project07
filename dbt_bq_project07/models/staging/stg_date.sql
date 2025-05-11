{{ config(materialized='view') }}

WITH time_data AS (
  SELECT
    time_stamp,
    local_time
  FROM {{ source('summary_your_dataset', 'change_data_type') }}
  WHERE time_stamp IS NOT NULL
)

SELECT
  -- Tạo khóa chính duy nhất (time_id) dựa trên time_stamp
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS date_id,
  EXTRACT(YEAR FROM time_stamp) AS year,
  EXTRACT(MONTH FROM time_stamp) AS month,
  EXTRACT(DAY FROM time_stamp) AS day,
  EXTRACT(WEEK FROM time_stamp) AS week_of_year,
  EXTRACT(QUARTER FROM time_stamp) AS quarter,
  FORMAT_DATE('%A', DATE(time_stamp)) AS day_of_week
FROM time_data
GROUP BY
  time_stamp,
  local_time,
  year,
  month,
  day,
  week_of_year,
  quarter,
  day_of_week