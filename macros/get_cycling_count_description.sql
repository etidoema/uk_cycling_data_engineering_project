{#
    This macro returns the description of the cycling_count based on number ranges starting from 30
#}

{% macro get_cycling_count_description(count) -%}

    case 
        when {{ count }} <= 30 then 'Very low cycling'
        when {{ count }} <= 50 then 'Low cycling'
        when {{ count }} <= 70 then 'Moderate-low cycling'
        when {{ count }} <= 90 then 'Moderate cycling'
        when {{ count }} <= 110 then 'Moderate-high cycling'
        when {{ count }} <= 130 then 'High-moderate cycling'
        when {{ count }} <= 150 then 'High cycling'
        else 'Very high cycling'
    end

{%- endmacro %}
