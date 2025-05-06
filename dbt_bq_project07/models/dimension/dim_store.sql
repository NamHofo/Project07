{{config(materialized='table')}}

SELECT
    store_id
FROM 
    {{ source('summary_your_dataset', 'change_data_type') }}