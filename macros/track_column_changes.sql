{#
    Collapses a snapshot into one row per continuous state of a column.
    Usage: {{ track_column_changes(ref('src_hosts_snapshot'), 'host_id', 'is_superhost') }}
#}

{% macro track_column_changes( snapshot_table, unique_key, column_to_change ) %}

WITH source AS (
    SELECT * FROM {{ ref( snapshot_table ) }}
)

, versions AS (
    SELECT
        {{ unique_key }},
        {{ dbt_utils.generate_surrogate_key( [unique_key, column_to_change, 'dbt_valid_from'] ) }} as event_id,
        {{ column_to_change }},
        LAG({{ column_to_change }}) OVER (PARTITION BY {{ unique_key }} ORDER BY dbt_valid_from, dbt_valid_to) AS prev_state,
        dbt_valid_from,
        dbt_valid_to,
    FROM source   
)

, flagged AS (
    SELECT *,
        CASE WHEN {{ column_to_change }} IS DISTINCT FROM prev_state THEN 1 ELSE 0 END AS is_change
    FROM versions
)

, grouped AS (
    SELECT *,
        SUM(is_change) OVER (PARTITION BY {{ unique_key }} ORDER BY dbt_valid_from) as grp
    FROM flagged
)

, final AS (
    SELECT 
        {{ unique_key }},
        min_by(event_id, dbt_valid_from) as event_id, 
        {{ column_to_change }},
        grp,
        MIN(dbt_valid_from) as valid_from,
        MAX(dbt_valid_to) as valid_to
    FROM grouped
    GROUP BY ALL
)

SELECT *
FROM final

{% endmacro %}