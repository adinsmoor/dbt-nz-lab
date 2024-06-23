{% snapshot dim_player_snapshot %}
    {{
        config(
            target_schema='dbt_ws_mark_wan_snapshot',
            unique_key='PLAYER_ID',
            strategy='check',
            check_cols = ['city', 'team_name', 'country_code']
        )
    }}

    select * from {{ ref('dim_players') }}
 {% endsnapshot %}