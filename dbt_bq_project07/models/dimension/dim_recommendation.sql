{{ config(materialized='table') }}

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(recommendation, CAST(recommendation_product_id AS STRING))) AS STRING) AS recommendation_id,
  recommendation,
  recommendation_product_id,
  recommendation_clicked_position,
  show_recommendation
FROM {{ source('summary_your_dataset', 'change_data_type') }}
WHERE recommendation_product_id IS NOT NULL
GROUP BY recommendation, recommendation_product_id, recommendation_clicked_position, show_recommendation