{{ config(materialized='table') }}

SELECT
    product_id,
    cat_id,
    collect_id,
    option.option_id,
    option.option_label,
    option.quality,
    option.quality_label,
    option.value_id,
    option.value_label,
    option.alloy,
    option.diamond,
    option.shapediamond
FROM {{ source('summary_your_dataset', 'change_data_type') }},
UNNEST(option) AS option