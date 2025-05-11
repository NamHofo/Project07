{{config(materialized='view')}}

SELECT
    user_id_db,
    email_address,
    device_id,
    ip,
    user_agent,
    resolution
FROM 
    {{ source('summary_your_dataset', 'change_data_type') }}