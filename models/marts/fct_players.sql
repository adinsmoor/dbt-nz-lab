with dim_players as (
   select * from {{ ref('dim_players') }}
)
, fct_events as (
   select * from {{ ref('fct_events') }}
)
,final as (
   select
       dim_players.player_id
       , player_name
       , weight
       , height
       , city
       , birth_date
       , affiliation_id
       , team_name
       , country_code
       , sum (case when event_type_name = 'goal' then 1 else 0 end) as goal_count
       , sum (case when event_type_name = 'miss' then 1 else 0 end) as miss_count
       , sum (case when event_type_name = 'card' then 1 else 0 end) as card_count
       , sum (case when event_type_name = 'pass' then 1 else 0 end) as pass_count
       , 1.0*(goal_count / nullif(miss_count + goal_count,0)) as goal_percentage
   from dim_players
   left join fct_events on dim_players.player_id = fct_events.player_id
   group by 1,2,3,4,5,6,7,8,9
)
select * from final
