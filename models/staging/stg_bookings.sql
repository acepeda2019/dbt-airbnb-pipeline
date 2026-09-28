{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='booking_id' 
)}}
WITH source as (

    SELECT * FROM {{ source('raw', 'bookings') }}

),

renamed as (

    SELECT
        booking_id,
        listing_id,
        booking_date,
        nights_booked,
        booking_amount,
        cleaning_fee,
        service_fee,
        booking_status,
        created_at
    FROM source

)

SELECT * 
FROM renamed
{%- if is_incremental() %}
WHERE created_at >= coalesce((select max(created_at) from {{ this }}), '1900-01-01')
{%- endif %}

