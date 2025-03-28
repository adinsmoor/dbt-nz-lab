WITH dim_players AS (
    SELECT * FROM {{ ref('dim_players') }}
)

, fct_events AS (
    SELECT * FROM {{ ref('fct_events') }}
)

, final AS (
    SELECT
        dim_p.player_id
        , player_name
        , weight
        , height
        , city
        , birth_date
        , affiliation_id
        , team_name
        , country_code
        , sum(CASE WHEN event_type_name = 'goal' THEN 1 ELSE 0 END) AS goal_count
        , sum(CASE WHEN event_type_name = 'miss' THEN 1 ELSE 0 END) AS miss_count
        , sum(CASE WHEN event_type_name = 'card' THEN 1 ELSE 0 END) AS card_count
        , sum(CASE WHEN event_type_name = 'pass' THEN 1 ELSE 0 END) AS pass_count
        , 1.0 * (goal_count / nullif(miss_count + goal_count, 0)) AS goal_percentage
    FROM
        dim_players AS dim_p
    LEFT JOIN fct_events AS fct_e ON dim_p.player_id = fct_e.player_id
    GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8, 9
)

SELECT * FROM final
