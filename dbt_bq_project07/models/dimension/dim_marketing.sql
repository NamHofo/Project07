{{ config(materialized='table') }}

SELECT
  CAST(FARM_FINGERPRINT(CONCAT(utm_source, utm_medium, current_url, referrer_url)) AS STRING) AS marketing_id,
  utm_source,
  utm_medium,
  current_url,
  referrer_url
FROM {{ source('summary_your_dataset', 'change_data_type') }}
WHERE utm_source IS NOT NULL
GROUP BY utm_source, utm_medium, current_url, referrer_url