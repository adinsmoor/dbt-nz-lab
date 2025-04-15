WITH players AS (SELECT * FROM {{ ref('dim_players') }})

, events AS (SELECT * FROM {{ ref('fct_events') }})



, final AS (
    {% set event_types= ['goal','miss','card','pass'] %}
    SELECT
        dim_players.player_id
        , player_name
        , weight
        , height
        , city
        , birth_date
        , affiliation_id
        , team_name
        , country_code
        {% for et in event_types %}
            , sum(
                CASE WHEN event_type_name = '{{ et }}' THEN 1 ELSE 0
                END
            ) AS {{ et }}_count
        {% endfor %}
        , 1.0
        * (goal_count / nullif(miss_count + goal_count, 0)) AS goal_percentage
    FROM dim_players
    LEFT JOIN fct_events ON dim_players.player_id = fct_events.player_id
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9
)

SELECT * FROM final
