{% macro calculate_median(numeric_column) %}
    percentile_cont(0.5) within group (order by {{ numeric_column }} )
{% endmacro %}


{% macro calculate_athena_median(numeric_column) %}
    approx_percentile({{ numeric_column }}, 0.5)
{% endmacro %}
