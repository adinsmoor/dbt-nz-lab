select 
    player.*,
    team.team_name, 
    team.country_code
from {{ ref('stg_player') }} player
    left join {{ ref('stg_team') }} team
    on player.affiliation_id = team.affiliation_id

