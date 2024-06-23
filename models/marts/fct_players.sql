{{
    config(
        materialized='table'
    )
}}

{% set event_types= ['goal','miss','card','pass'] %}

select
       player.player_id
       , player_name
       , weight
       , height
       , city
       , birth_date
       , affiliation_id
       , team_name
       , country_code
--       , sum (case when event_type_name = 'goal' then 1 else 0 end) as goal_count
--       , sum (case when event_type_name = 'miss' then 1 else 0 end) as miss_count
--       , sum (case when event_type_name = 'card' then 1 else 0 end) as card_count
--       , sum (case when event_type_name = 'pass' then 1 else 0 end) as pass_count
        {% for et in event_types %}
            , sum (case when event_type_name = '{{et}}' then 1 else 0 end) as {{et}}_count
        {% endfor %}
       , 1.0*(goal_count / nullif(miss_count + goal_count,0)) as goal_percentage
from {{ ref('dim_players') }} player
left join {{ ref('fct_events') }} event
    on player.player_id = event.player_id
group by 1,2,3,4,5,6,7,8,9
