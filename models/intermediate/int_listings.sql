WITH source as (

    SELECT * FROM {{ ref('stg_listings') }}

),

renamed as (

    SELECT
        listing_id,
        host_id,
        property_type,
        room_type,
        city,
        country,
        accommodates,
        bedrooms,
        bathrooms,
        price_per_night,
        created_at

    FROM source

)

SELECT * 
FROM renamed