{{ config(materialized='table') }}

SELECT
  order_id,
  is_paypal
FROM {{ source('summary_your_dataset', 'change_data_type') }}
WHERE order_id IS NOT NULL
GROUP BY order_id, is_paypal