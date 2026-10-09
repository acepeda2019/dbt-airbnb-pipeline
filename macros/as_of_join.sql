{#
    Join condition for looking up a change-history row as of a date.
    Falls back to the earliest known state when the date predates all history.
    Usage: AND {{ as_of_join('lph', 'b.booking_date') }}
#}

{%- macro as_of_join(alias, as_of_date) -%}
{{ as_of_date }} < {{ alias }}.valid_to
AND ( {{ as_of_date }} >= {{ alias }}.valid_from OR {{ alias }}.grp=1 )
{%- endmacro -%}