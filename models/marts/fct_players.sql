{% set event_types =['goal','miss','card','pass'] %}
SELECT
    players.player_id
    , player_name
    , weight
    , height
    , city
    , birth_date
    , affiliation_id
    , team_name
    , country_code
    {% for et in event_types %}
        , sum(CASE WHEN event_type_name = '{{et}}' THEN 1 ELSE 0 END) AS {{et}}_count
    {% endfor %}
    , 1.0 * (goal_count / nullif(miss_count + goal_count, 0)) AS goal_percentag
FROM {{ ref('dim_players') }} AS players
LEFT JOIN {{ ref('fct_events') }} AS events
    ON players.player_id = events.player_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9


