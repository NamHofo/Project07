{{ config(materialized='table') }}

WITH checkout_data AS (
  SELECT
    order_id,
    time_stamp,
    local_time,
    user_id_db,
    ip,
    product_id,
    store_id,
    price,
    is_paypal,
    ARRAY_LENGTH(cart_products) AS cart_product_count,
    (SELECT SUM(SAFE_CAST(cp.price AS FLOAT64) * SAFE_CAST(cp.amount AS FLOAT64)) 
     FROM UNNEST(cart_products) cp 
     WHERE cp.price IS NOT NULL AND cp.amount IS NOT NULL) AS total_price,
    (SELECT SUM(SAFE_CAST(cp.amount AS INT64)) 
     FROM UNNEST(cart_products) cp 
     WHERE cp.amount IS NOT NULL) AS quantity
  FROM {{ ref('stg_change_data_type') }}
  WHERE collection = 'checkout_success'
    AND order_id IS NOT NULL
)

SELECT
  order_id,
  CAST(FARM_FINGERPRINT(CONCAT(CAST(time_stamp AS STRING), CAST(local_time AS STRING))) AS STRING) AS time_id,
  user_id_db,
  ip as location_id,
  product_id,
  store_id,
  total_price,
  quantity,
  is_paypal,
  cart_product_count
FROM checkout_data
WHERE total_price IS NOT NULL