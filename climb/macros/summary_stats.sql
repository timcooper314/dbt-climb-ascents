{% macro calculate_median(numeric_column) %}

percentile_cont(0.5) within group (order by {{ numeric_column }} )

{% endmacro %}
