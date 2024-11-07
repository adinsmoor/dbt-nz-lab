{{
    config(
        materialized='table'
    )
}}

with players as (
    select * from {{ source('fifa', 'player') }}
)

select
    id as player_id,
    player_first_name,
    player_middle_name,
    player_last_name,
    player_known_name,
    birth_date,
    weight,
    height,
    city,
    national_team_affiliation_id,
    affiliation_id,
    concat(player_first_name, ' ', player_last_name) as player_name,
    datediff('year', birth_date, '2018-06-14') as age_at_tournament_start
from players
