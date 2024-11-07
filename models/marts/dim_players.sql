with players as (
    select * from {{ ref('stg_player') }}
),

teams as (
    select * from {{ ref('stg_team') }}
)

select
    players.*,
    teams.country_code,
    teams.team_name
from
    players
natural join teams
