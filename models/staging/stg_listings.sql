WITH source as (

    SELECT * FROM {{ source('raw', 'listings') }}

),

renamed as (

    SELECT
        listing_id,
        host_id,
        upper(trim(property_type)) as property_type,
        upper(trim(room_type)) as room_type,
        upper(trim(city)) as city,
        upper(trim(country)) as country,
        accommodates,
        bedrooms,
        bathrooms,
        price_per_night,
        created_at

    FROM source

)

SELECT * FROM renamed