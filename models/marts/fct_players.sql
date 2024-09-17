WITH dim_players as
(
    select *
    from {{ ref('dim_players') }}
)
, fct_events as
(
    select *
    from {{ ref('fct_events') }}
)
, final as 
(
    {% set event_types=['goal', 'miss', 'card', 'pass'] %}

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
        , sum(case when fct_events.event_type_name = '{{et}}' then 1 else 0 end) as {{et}}_count
        {% endfor %}
    FROM dim_players
    left join fct_events
        on dim_players.player_id = fct_events.player_id
    -- group by all
    group by 1,2,3,4,5,6,7,8,9
)
SELECT *
FROM final