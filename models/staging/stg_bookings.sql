WITH source AS (
    SELECT * FROM {{ source('airbnb', 'bookings') }}
)

SELECT * FROM source