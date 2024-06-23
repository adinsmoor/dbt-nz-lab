WITH player AS (
    SELECT * FROM {{ ref('stg_player') }}
)

, team AS (
    SELECT * FROM {{ ref('stg_team') }}
)

, final AS (
    SELECT
        player.player_id
        , player.affiliation_id
        , player.player_name
        , player.weight
        , player.height
        , player.city
        , player.birth_date
        , player.age
        , team.team_name
        , team.country_code
    FROM player
    LEFT JOIN team ON player.affiliation_id = team.affiliation_id
)

SELECT * FROM final
