WITH cte_players AS (
    SELECT * FROM {{ ref('stg_player') }}
)

, cte_teams AS (
    SELECT * FROM {{ ref('stg_team') }}
)

, final AS (
    SELECT
        cte_players.*
        , cte_teams.team_name
        , cte_teams.country_code
    FROM
        cte_players
    LEFT JOIN
        cte_teams
        ON
            cte_players.affiliation_id = cte_teams.affiliation_id

)

SELECT * FROM final
