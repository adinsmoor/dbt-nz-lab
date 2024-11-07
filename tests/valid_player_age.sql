{{
    config(
        severity = 'warn',
        error_if = '>10'
        )
}}


with 
players as (select * from {{ ref('dim_players') }}) 

select  player_id, player_name 
from players 
where 1=1
and (age < 18 or age > 36)