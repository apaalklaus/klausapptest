{% macro test_range_check(model, column_name, lower_bound, upper_bound) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} < {{ lower_bound }} OR {{ column_name }} > {{ upper_bound }}

{% endmacro %}