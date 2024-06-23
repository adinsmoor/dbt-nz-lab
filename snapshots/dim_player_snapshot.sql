{% snapshot dim_player_snapshot %}
    {{
        config(
            target_schema='dbt_ws_bbuhain',
            target_databas='APACWORKSHOP',
            unique_key='player_id',
            strategy='check',
            check_cols = ['city', 'team_name', 'country_code']

        )
    }}

    select * from {{ ref('dim_players') }}
 {% endsnapshot %}