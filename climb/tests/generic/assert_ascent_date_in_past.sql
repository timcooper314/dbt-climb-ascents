{% test assert_ascent_date_in_past(model, column_name) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} > current_date

{% endtest %}
