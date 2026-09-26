{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- if target.schema == 'default' -%}

        {{ default_database }}

    {%- else -%}

        {{ default_database }}_{{ target.schema }}

    {%- endif -%}

{%- endmacro %}
 ~/Doc/G/dbt-fundament