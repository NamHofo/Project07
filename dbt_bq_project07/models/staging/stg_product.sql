{{ config(materialized='view') }}

SELECT
    product_id,
    product_name
FROM 
    {{ source('summary_your_dataset', 'product_name_crawl') }}