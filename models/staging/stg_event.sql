with events as (
    select * from {{ source('fifa', 'event') }}
)

select
    event_id,
    event_type_id,
    game_id,
    period_id,
    period_minute,
    period_second,
    player_id,
    team_id,
    timestamp as event_time,
    concat(event_id, team_id, game_id) as event_pk
-- remove irrelevant fields:
--  , outcome
--  , x
--  , y
from events
