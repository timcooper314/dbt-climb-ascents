{% macro flatten_json(model_name, json_column) %}

{% set json_column_query %}
SELECT 
    distinct(json_object_keys({{ json_column }}::json)) as column_name
from {{ model_name }}
{% endset %}


{% set results = run_query(json_column_query) %}

{% if execute %}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

select
    {% for column_name in results_list %}
    {{ json_column }}::jsonb ->> '{{ escape_single_quotes(column_name) }}' as {{ column_name}}{% if not loop.last %},{% endif %}
    {% endfor %}
from {{ model_name }}


{% endmacro %}
