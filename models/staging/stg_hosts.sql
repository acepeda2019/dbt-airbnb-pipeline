WITH source AS (
    SELECT * FROM {{ source('airbnb', 'hosts') }}
)

SELECT * FROM source