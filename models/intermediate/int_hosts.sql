WITH source as (

    SELECT * FROM {{ ref('stg_hosts') }}

),

hosts as (

    SELECT
        host_id,
        host_name,
        host_since,
        datediff(month, host_since, current_date) > 12 as is_seasoned_host,
        is_superhost,
        response_rate,
        created_at

    FROM source

)

SELECT * 
FROM hosts