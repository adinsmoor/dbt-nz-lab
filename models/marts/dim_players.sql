select
    player.*
    , team.team_name
    , team.country_code
from {{ ref('stg_fifa__player') }} as player
left join {{ ref('stg_team') }} as team
    on player.affiliation_id = team.affiliation_id
