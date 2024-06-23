WITH

source AS (

    SELECT * FROM {{ source('fifa', 'player') }}

)

, renamed AS (

    SELECT
        id AS player_id
        , player_first_name
        , player_middle_name
        , player_last_name
        , player_known_name
        , birth_date
        , weight
        , height
        , city
        , national_team_affiliation_id
        , affiliation_id
        , concat(player_first_name, player_last_name) AS player_name
        , datediff(YEAR, birth_date, '2018-06-14') AS age

    FROM source

)

SELECT * FROM renamed
