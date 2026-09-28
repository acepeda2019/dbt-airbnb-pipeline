WITH source AS (
    SELECT * FROM {{ source('airbnb', 'listings') }}
)

SELECT * FROM source