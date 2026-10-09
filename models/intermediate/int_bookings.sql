{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='booking_id'
)}}

WITH source as (

    SELECT * FROM {{ ref('stg_bookings') }}

),

bookings as (

    SELECT
        booking_id,
        listing_id,
        booking_date,
        nights_booked,
        booking_amount,
        cleaning_fee,
        service_fee,
        cleaning_fee + service_fee as total_fees,
        {{ multiply('nights_booked', 'booking_amount', 4) }} + total_fees as total_revenue,
        booking_status,
        created_at
    FROM source

)

SELECT * 
FROM bookings
{%- if is_incremental() %}
WHERE created_at >= coalesce((select max(created_at) from {{ this }}), '1900-01-01')
{%- endif -%}