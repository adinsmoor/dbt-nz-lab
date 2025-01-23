WITH stg_players AS (
    SELECT * FROM {{ ref('stg_players') }}
)

, stg_team AS (
    SELECT * FROM {{ ref('stg_team') }}
)

SELECT
    p.*
    , t.team_name
    , t.country_code
FROM stg_players AS p
INNER JOIN stg_team AS t
    ON p.affiliation_id = t.affiliation_id
