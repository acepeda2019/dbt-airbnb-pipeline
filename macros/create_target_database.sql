{% macro create_target_database() %}
    {% set sql %}
        CREATE DATABASE IF NOT EXISTS {{ target.database }}_{{ target.schema }}
    {% endset %}
    {% do run_query(sql) %}
{% endmacro %}