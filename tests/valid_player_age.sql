{{
    config(
        severity = 'warn',
        error_if = '>10'
        )
}}

select
    player_id,
    player_name,
    age
from {{ ref('dim_players') }}
where age < 18 or age > 36
