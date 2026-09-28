{%- macro multiply(left, right, precision=2) -%}
    ROUND( {{ left }} * {{ right }}, {{ precision }})
{%- endmacro -%}