{{ config(materialized='table') }}

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(CAST(cp.product_id AS STRING), cp.amount, CAST(cp.price AS STRING))) AS STRING) AS cart_product_id,
  cp.product_id,
  cp.amount,
  cp.price,
  cp.currency,
  opt.option_id,
  opt.option_label,
  opt.quality,
  opt.quality_label,
  opt.value_id,
  opt.value_label,
  opt.alloy,
  opt.diamond,
  opt.shapediamond
FROM {{ source('summary_your_dataset', 'change_data_type') }},
UNNEST(cart_products) AS cp,
UNNEST(cp.option) AS opt
WHERE cp.product_id IS NOT NULL