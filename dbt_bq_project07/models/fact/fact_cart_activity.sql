{{ config(materialized='table') }}

WITH cart_data AS (
  SELECT
    time_stamp,
    local_time,
    user_id_db,
    CAST(FARM_FINGERPRINT(CONCAT(CAST(cp.product_id AS STRING), cp.amount, CAST(cp.price AS STRING))) AS STRING) AS cart_product_id,
    COUNT(*) AS add_to_cart_count
  FROM {{ source('summary_your_dataset', 'change_data_type') }},
  UNNEST(cart_products) AS cp
  WHERE cp.product_id IS NOT NULL
  GROUP BY time_stamp, local_time, user_id_db, cart_product_id
)

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(user_id_db AS STRING), cart_product_id)) AS STRING) AS fact_id,
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS time_id,
  user_id_db,
  cart_product_id,
  add_to_cart_count
FROM cart_data