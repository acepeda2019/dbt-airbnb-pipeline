{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='booking_id' 
)}}
WITH source AS (
    SELECT * FROM {{ source('airbnb', 'bookings') }}
)

SELECT *
FROM source
WHERE 1=1
{% if is_incremental() %}
  and CREATED_AT >= coalesce((select max(CREATED_AT) from {{ this }}), '1900-01-01')
{% endif %}