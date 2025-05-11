{{ config(materialized='view') }}

WITH cleaned_data AS (
  SELECT
    -- Các trường cơ bản
    SAFE_CAST(order_id AS INT64) AS order_id,
    SAFE_CAST(time_stamp AS TIMESTAMP) AS time_stamp,
    SAFE_CAST(local_time AS DATETIME) AS local_time,
    SAFE_CAST(user_id_db AS INT64) AS user_id_db,
    SAFE_CAST(device_id AS STRING) AS device_id,
    SAFE_CAST(ip AS STRING) AS ip,
    SAFE_CAST(user_agent AS STRING) AS user_agent,
    SAFE_CAST(resolution AS STRING) AS resolution,
    SAFE_CAST(api_version AS FLOAT64) AS api_version,
    SAFE_CAST(store_id AS INT64) AS store_id,
    SAFE_CAST(product_id AS INT64) AS product_id,
    SAFE_CAST(cat_id AS INT64) AS cat_id,
    SAFE_CAST(collect_id AS INT64) AS collect_id,
    SAFE_CAST(viewing_product_id AS INT64) AS viewing_product_id,
    SAFE_CAST(recommendation_product_id AS INT64) AS recommendation_product_id,
    SAFE_CAST(recommendation_clicked_position AS INT64) AS recommendation_clicked_position,

    -- Trường price và tiền tệ
    SAFE_CAST(price AS FLOAT64) AS price,
    SAFE_CAST(currency AS STRING) AS currency,

    -- Trường boolean
    SAFE_CAST(is_paypal AS BOOL) AS is_paypal,

    -- Trường marketing
    SAFE_CAST(utm_source AS STRING) AS utm_source,
    SAFE_CAST(utm_medium AS STRING) AS utm_medium,
    SAFE_CAST(current_url AS STRING) AS current_url,
    SAFE_CAST(referrer_url AS STRING) AS referrer_url,

    -- Trường tìm kiếm
    SAFE_CAST(key_search AS STRING) AS key_search,

    -- Trường email và các trường khác
    SAFE_CAST(email_address AS STRING) AS email_address,
    SAFE_CAST(show_recommendation AS STRING) AS show_recommendation,
    SAFE_CAST(recommendation AS STRING) AS recommendation,

    -- Xử lý mảng cart_products
    ARRAY(
      SELECT AS STRUCT
        SAFE_CAST(cp.product_id AS INT64) AS product_id,
        SAFE_CAST(cp.amount AS STRING) AS amount, -- Giữ STRING để xử lý linh hoạt sau
        SAFE_CAST(cp.price AS FLOAT64) AS price,
        SAFE_CAST(cp.currency AS STRING) AS currency,
        ARRAY(
          SELECT AS STRUCT
            SAFE_CAST(opt.option_id AS INT64) AS option_id,
            SAFE_CAST(opt.option_label AS STRING) AS option_label,
            SAFE_CAST(opt.quality AS STRING) AS quality,
            SAFE_CAST(opt.quality_label AS STRING) AS quality_label,
            SAFE_CAST(opt.value_id AS INT64) AS value_id,
            SAFE_CAST(opt.value_label AS STRING) AS value_label,
            SAFE_CAST(opt.alloy AS STRING) AS alloy,
            SAFE_CAST(opt.diamond AS STRING) AS diamond,
            SAFE_CAST(opt.shapediamond AS INT64) AS shapediamond
          FROM UNNEST(cp.option) AS opt
        ) AS option
      FROM UNNEST(cart_products) AS cp
    ) AS cart_products,

    -- Xử lý mảng option
    ARRAY(
      SELECT AS STRUCT
        SAFE_CAST(opt.option_id AS INT64) AS option_id,
        SAFE_CAST(opt.option_label AS STRING) AS option_label,
        SAFE_CAST(opt.quality AS STRING) AS quality,
        SAFE_CAST(opt.quality_label AS STRING) AS quality_label,
        SAFE_CAST(opt.value_id AS INT64) AS value_id,
        SAFE_CAST(opt.value_label AS STRING) AS value_label,
        SAFE_CAST(opt.alloy AS STRING) AS alloy,
        SAFE_CAST(opt.diamond AS STRING) AS diamond,
        SAFE_CAST(opt.shapediamond AS INT64) AS shapediamond
      FROM UNNEST(option) AS opt
    ) AS options,

    -- Trường collection để lọc fact table
    SAFE_CAST(collection AS STRING) AS collection
  FROM {{ source('summary_your_dataset', 'change_data_type') }}

)

SELECT *
FROM cleaned_data