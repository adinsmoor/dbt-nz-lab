with dim_players as (
    select * from {{ ref('dim_players') }}
)
, fct_events as (
    select * from {{ ref('fct_events') }}
)

select
    p.player_id
    ,p.full_name
    ,{{dbt_utils.pivot('e.event_type_name',['goal','miss','pass','card'], agg='sum', prefix='sum_')}}
from fct_events e 
inner join dim_players p 
    ON e.player_id = p.player_id 
group by
    p.player_id
    ,p.full_name
