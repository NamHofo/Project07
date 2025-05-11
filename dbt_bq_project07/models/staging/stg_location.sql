{{ config(materialized='view') }}

SELECT 
    ip as location_id,
    region as region_name,
    country_name,
    city as city_name
FROM 
    {{source('summary_your_dataset','ip2_location')}}