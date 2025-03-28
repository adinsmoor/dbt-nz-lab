WITH player AS (
    SELECT * FROM {{ ref('stg_player') }}
),

team AS (
    SELECT * FROM {{ ref('stg_team') }}
),

final AS (
    SELECT
        p.player_id,
        p.affiliation_id,
        p.player_name,
        p.weight,
        p.height,
        p.city,
        p.birth_date,
        p.age,
        t.team_name,
        t.country_code
    FROM
        player AS p
    LEFT JOIN team AS t ON p.affiliation_id = t.affiliation_id
)

SELECT * FROM final
