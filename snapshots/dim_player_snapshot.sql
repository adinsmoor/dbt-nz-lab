{% snapshot snapshot_name %}
    {{
        config(
            target_schema='dbt_mkean',
            unique_key='player_id',
            strategy='check',
            check_cols = ['city', 'team_name', 'country_code']
        )
    }}

    select * from {{ ref('dim_players') }}
 {% endsnapshot %}