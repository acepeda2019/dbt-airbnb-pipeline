WITH bookings AS (
    SELECT * FROM {{ ref('int_bookings') }}
),

listings AS (
    SELECT * FROM {{ ref('int_listings') }}
),

hosts AS (
    SELECT * FROM {{ ref('int_hosts') }}
),

booking_status_history AS (
    SELECT 
        booking_id, 
        COUNT(*) - 1 AS booking_status_change_ct 
    FROM {{ ref('int_booking_changes_status')}}
    GROUP BY booking_id
),

listing_price_history AS (
    SELECT * FROM {{ ref('int_listings_changes_price_per_night') }}
),

superhost_history AS (
    SELECT * FROM {{ ref('int_hosts_changes_superhost') }}
),

response_rate_history AS (
    SELECT * FROM {{ ref('int_hosts_changes_response_rate') }}
),

final AS (
    SELECT
        -- Keys
        b.booking_id,
        b.listing_id,
        l.host_id,

        -- Listing Details
        l.property_type,
        l.room_type,
        l.city,
        l.country,
        l.accommodates,
        l.bedrooms,
        l.bathrooms,

        -- Host Details
        h.host_name,
        h.host_since,
        h.is_seasoned_host,

        -- Current States
        h.is_superhost AS current_is_superhost,
        h.response_rate AS current_response_rate,
        l.price_per_night AS current_price_per_night,

        -- Historical States 
        sh.is_superhost AS booking_is_superhost,
        rrh.response_rate AS booking_response_rate,
        lph.price_per_night as booking_price_per_night,

        -- Backfill Flags: Flags when valid_from dates pre-date the booking date
        b.booking_date < lph.valid_from AS is_price_backfilled,
        b.booking_date < sh.valid_from  AS is_superhost_backfilled,
        b.booking_date < rrh.valid_from AS is_response_rate_backfilled,
        
        COALESCE(bsh.booking_status_change_ct, 0) AS booking_status_change_ct,
        b.booking_status,
        b.booking_date,
        b.nights_booked,
        b.booking_amount,
        b.cleaning_fee,
        b.service_fee,
        b.total_fees,
        b.total_revenue

    FROM bookings b
        LEFT JOIN listings l ON b.listing_id = l.listing_id
        LEFT JOIN hosts h ON l.host_id = h.host_id
        LEFT JOIN booking_status_history bsh 
            ON b.booking_id = bsh.booking_id 
        LEFT JOIN listing_price_history lph 
            ON l.listing_id = lph.listing_id 
            AND {{ as_of_join('lph', 'b.booking_date') | indent(12) }}
        LEFT JOIN superhost_history sh 
            ON h.host_id = sh.host_id
            AND {{ as_of_join('sh', 'b.booking_date') | indent(12) }}
        LEFT JOIN response_rate_history rrh 
            ON h.host_id = rrh.host_id
            AND {{ as_of_join('rrh', 'b.booking_date') | indent(12) }}
)

SELECT *
FROM final
