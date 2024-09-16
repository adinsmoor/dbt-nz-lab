{% macro ws_schema_cleanup(database, prefix) %}
    {% set schemas_query %}
        SELECT schema_name
        FROM {{ database }}.information_schema.schemata
        WHERE schema_name LIKE '{{prefix}}%'
    {% endset %}
    
    {% set result = run_query(schemas_query) %}
    {% set results_list=result.columns[0].values() %}

    
    {% if results_list %}
    {{ log(results_list) }}
        {% for row in results_list %}
            {% set schema_name = row %}
            {% set drop_schema_query %}
                DROP SCHEMA IF EXISTS {{ database }}.{{ schema_name }} CASCADE;
            {% endset %}
            {{ run_query(drop_schema_query) }}
            {{ log("Dropped schema: " ~ schema_name, info=True) }}
        {% endfor %}
    {% else %}
        {{ log("No schemas starting with DBT_WS found in the " ~ database ~ " database.", info=True) }}
    {% endif %}
{% endmacro %}