{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='booking_id'
)}}

SELECT
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    NIGHTS_BOOKED,
    BOOKING_AMOUNT,
    CLEANING_FEE,
    SERVICE_FEE,
    CLEANING_FEE + SERVICE_FEE AS TOTAL_FEES,
    {{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT') }} + TOTAL_FEES AS REVENUE,
    BOOKING_STATUS,
    CREATED_AT
FROM {{ ref('stg_bookings') }}
WHERE 1=1
{% if is_incremental() %}
  AND CREATED_AT >= coalesce((select max(CREATED_AT) from {{ this }}), '1900-01-01')
{% endif %}
