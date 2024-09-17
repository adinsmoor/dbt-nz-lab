{% snapshot dim_player_scd2 %}
    {{
        config(
            target_schema='vitormelo_snapshots',
            unique_key='player_id',
            strategy='check',
            check_cols='all'
        )
    }}
    select *
    from {{ ref('stg_fifa__player')}}
{% endsnapshot %}