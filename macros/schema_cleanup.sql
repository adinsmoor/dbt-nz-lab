{% macro schema_cleanup(database_name, prefix) %}
{% set dev_prefix = prefix ~ '%' %}
{# Get the list of schemas in the database #}
{% set schemas_query %}
    SELECT schema_name
    FROM information_schema.schemata
    WHERE catalog_name = 'APACWORKSHOP'
    AND lower(SCHEMA_NAME) like '{{ dev_prefix }}'
{% endset %}

{% set results = run_query(schemas_query) %}
{{ log(results.columns[0], info=True) }}

{% set schemas = results.columns[0] if results else [] %}
{{ log("schemas = "~ schemas, info=True) }}


{# Filter schemas starting with the given prefix #}
{% set target_schemas = [] %}
{% for schema in schemas %}
    {% if schema.startswith(prefix) %}
        {% do target_schemas.append(schema) %}
    {% endif %}
{% endfor %}

{# Generate and execute the drop schema statements #}
{% for schema in target_schemas %}
    {# Drop all objects in the schema first #}
    {% set drop_objects_query %}
        SELECT 'DROP ' || table_type || ' ' || table_schema || '.' || table_name || ' CASCADE;' AS drop_statement
        FROM information_schema.tables
        WHERE table_schema = '{{ schema }}'
    {% endset %}
    {% set drop_objects_results = run_query(drop_objects_query) %}
    {% set drop_objects = drop_objects_results.columns[0] if drop_objects_results else [] %}
    {% for drop_statement in drop_objects %}
        {{ log(drop_statement, info=True) }}
        {% do run_query(drop_statement) %}
    {% endfor %}

    {# Drop the schema itself #}
    {% set drop_schema_query = 'DROP SCHEMA IF EXISTS ' ~ schema ~ ' CASCADE;' %}
    {{ log(drop_schema_query, info=True) }}
    {% do run_query(drop_schema_query) %}
{% endfor %}

{% endmacro %}
