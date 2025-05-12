# **Revenue Data Analysis Project (dbt, BigQuery, Looker Studio)**

## 1) Overview

This project builds a data pipeline to analyze revenue and business performance using raw data stored in **BigQuery**. The pipeline leverages **dbt** to transform data into dimension and fact tables, which are then visualized in **Looker Studio** dashboards. Key objectives include:

- Processing raw data from two sources: `change_data_type` and `ip2_location`.
- Creating dimension tables (`dim_time`, `dim_user`, `dim_product`, `dim_option`, `dim_location`) and a fact table (`fact_checkout_success`).
- Building dashboards to explore revenue trends, time-based patterns, geographic distribution, and product performance.

## 📚 Table of Contents

1. [Overview](#1-overview)  
2. [Source Data](#2-source-data)  
3. [Implementation Steps](#3-implementation-steps)  
    - [a. Data Staging with dbt](#a-data-staging-with-dbt)  
    - [b. Building Dimension Tables](#b-building-dimension-tables)  
    - [c. Creating Fact Table](#c-creating-fact-table)  
    - [d. Schema Definition](#d-schema-definition)  
4. [Data Visualization in Looker Studio](#4-data-visualization-in-looker-studio)  
    - [a. Data Connection](#a-data-connection)  
    - [b. Dashboard Building](#b-dashboard-building)  
    - [c. Dashboard Optimization](#c-dashboard-optimization)  
5. [Tools Used](#5-tools-used)  
6. [Project Setup Guide](#6-project-setup-guide)  
    - [a. Requirements](#a-requirements)  
    - [b. DBT Configuration](#b-dbt-configuration)  
    - [c. Looker Studio Dashboard Setup](#c-looker-studio-dashboard-setup)  
7. [Achievements](#7-achievements)  
8. [Limitations and Future Improvements](#8-limitations-and-future-improvements)  
9. [Author](#9-author)  


---

## 2) Source Data

Data is stored in **Google BigQuery**:

- **Project**: `peppy-primacy-455413-d8`
- **Dataset**: `summary`
- **Raw Tables**:
    - `change_data_type`: Transaction data with fields like `order_id`, `time_stamp`, `ip`, `product_id`, `cart_products`, etc.
    - `ip2_location`: Location data with fields like `ip`, `region`, `country_name`, `city`.
- **Start Date**: April 15, 2025
- **End Date**: May 12, 2025

---

## 3. Implementation Steps

### a. **Data Staging with dbt**

- **`stg_change_data_type`**:
    
    Cleans and casts data types (e.g., `option_id` to `INT64`, `price` to `FLOAT64`). Handles product options using `UNNEST()`.
    
- **`stg_location`**:
    
    Processes `ip2_location` data. Renames `ip` to `location_id` (later replaced by a surrogate key).
    
- **`stg_date`**:
    
    Extracts date components (day, month, year, hour, etc.) from timestamps.
    
- **`stg_product`**:
    
    Extracts `product_id` and `product_name`.
    
- **`stg_user`**:
    
    Includes user-related fields from transaction data.
    

---

### b. **Building Dimension Tables**

- **`dim_date`**:
    
    Date dimension with extracted time fields.
    
    **Primary key**: `date_id`.
    
- **`dim_user`**:
    
    Includes user information like email and device.
    
    **Primary key**: `user_id_db`.
    
- **`dim_product`**:
    
    Unique product-level details.
    
    **Primary key**: `product_id`.
    
- **`dim_location`**:
    
    Uses `FARM_FINGERPRINT(ip, region, country_name, city)` for a surrogate key.
    
    **Primary key**: `location_id`.
    
- **`dim_store`**:
    
    Contains store-related data (`store_id`, `store_name`).
    

---

### c. **Creating Fact Table**

- **`fact_checkout_success`**:
    
    Computes metrics like `total_price`, `quantity`, `paypal_fee`.
    
    Joins with dimensions via `time_id`, `user_id_db`, `product_id`, `location_id`.
    
    **Primary key**: `fact_id` (surrogate key).
    

---

### d. **Schema Definition**

The `schema.yml` file includes:

- **Tests**: `unique` and `not_null` constraints for primary keys.
- **Descriptions**: Detailed column documentation.

---

## 4) Data Visualization in Looker Studio

### a. **Data Connection**

- Connect Looker Studio to BigQuery:
    
    Project: `peppy-primacy-455413-d8`
    
    Dataset: `summary`
    
- Use **Blend Data** to join `fact_checkout_success` with dimension tables (`dim_time`, `dim_location`, etc.) via keys.

---

### b. **Dashboard Building**

- **Revenue Analysis**:
    
    Charts showing total revenue and revenue by product category.
    
- **Geographic Distribution**:
    
    Heat maps displaying revenue by `region`, `country_name`.
    
- **Time-based Trends**:
    
    Time series charts using `month` (from `dim_time`) and `total_price`.
    
- **Product Performance**:
    
    Bar charts of revenue by product and product option.
    

---

### c. **Dashboard Optimization**

- Add interactive **Date Range Controls** and **Dropdown Filters**.
- Format currency as VND and display Vietnamese month names (e.g., "Tháng 1", "Tháng 2").

---

## 5. Tools Used

- **Google BigQuery**: Data storage and query engine.
- **dbt (Data Build Tool)**: Data transformation and modeling.
- **Looker Studio**: Visualization and dashboarding.
- **GitHub**: Version control and documentation.

---

## 6) Project Setup Guide

### 1. Requirements

- Google Cloud account with BigQuery access.
- Install dbt with BigQuery adapter:

```python
pip install dbt-bigquery
```

- Free Looker Studio account.

### 2. DBT Configuration

1. **Clone the repository**:

```python
git clone <repository-url>
cd dbt_bq_project07
```

1. **Configure `~/.dbt/profiles.yml`**:

```python
dbt_bq_project07:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: peppy-primacy-455413-d8
      dataset: summary
      threads: 4
      keyfile: /path/to/service-account-key.json
```

1. **Run dbt models**:

```python
dbt run --select stg_change_data_type stg_location
dbt run --select dim_time dim_user dim_product dim_option dim_location
dbt run --select fact_checkout_success
```

### 3. Looker Studio Dashboard Setup

1. Visit [Looker Studio](https://lookerstudio.google.com/).
2. Connect to BigQuery dataset: `summary`.
3. Use **Blend Data** to join dimension and fact tables.
4. Build charts as described above.

---

## 7) Achievements

- **Complete Data Pipeline**: From raw data to analytical-ready fact and dimension tables.
- **Interactive Dashboard**: Revenue, time trends, geolocation insights, and product performance.
- **Optimized Modeling**:
    - Unique dimension keys.
    - Surrogate keys for locations (IP deduplication and stability).

---

## 8) Limitations and Future Improvements

- **Performance**: Optimize BigQuery queries for large datasets using partitioning and clustering.
- **Looker Studio Integration**: Replace `Blend Data` with pre-joined BigQuery views to improve performance.
- **Location Accuracy**: Enhance IP mapping by including timestamp-based matching or enriched geolocation data.

---

## 9) Author

- **NguyenHoNam**
    
    Email: hofonam24@gmail.com

![gvto.svg](https://github.com/NamHofo/Project07/blob/main/gvto.svg)
