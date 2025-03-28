WITH dim_players AS (
    SELECT * FROM {{ ref('dim_players') }}
)

, fct_events AS (
    SELECT * FROM {{ ref('fct_events') }}
)

, final AS (
    {% set event_types = ['goal', 'miss', 'card', 'pass'] %}
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
        {% for et in event_types %}
        , sum( case when event_type_name = '{{et}}' then 1 else 0 end) as {{et}}_count
        {% endfor %}
        , 1.0 * (goal_count / nullif(miss_count + goal_count, 0)) AS goal_percentage
    FROM
        dim_players AS dim_p
    LEFT JOIN fct_events AS fct_e ON dim_p.player_id = fct_e.player_id
    GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8, 9
)

SELECT * FROM final
