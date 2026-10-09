WITH source as (

    SELECT * FROM {{ source('raw', 'hosts') }}

),

renamed as (

    SELECT
        host_id,
        upper(trim(host_name)) as host_name,
        host_since,
        is_superhost,
        response_rate,
        created_at

    FROM source

)

SELECT * FROM renamed