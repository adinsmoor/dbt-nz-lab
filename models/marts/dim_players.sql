SELECT
    player.*
    , team.country_code
    , team.team_name
FROM {{ ref('stg_player') }} AS player
LEFT JOIN {{ ref('stg_team') }} AS team
    ON player.affiliation_id = team.affiliation_id
