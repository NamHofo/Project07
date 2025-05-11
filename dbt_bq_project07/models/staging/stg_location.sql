{{ config(materialized='view') }}

SELECT 
    ip as location_id,
    region,
    country_name,
    city
FROM 
    {{source('summary_your_dataset','ip2_location')}}