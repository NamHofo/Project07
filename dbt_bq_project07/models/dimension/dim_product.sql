{{ config(materialized='table') }}

SELECT DISTINCT
    product_id,
    product_name
FROM {{ ref('stg_product') }}
WHERE product_id IS NOT NULL