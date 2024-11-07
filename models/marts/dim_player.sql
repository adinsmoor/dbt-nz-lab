with stg_player AS (

select * from {{ ref('stg_fifa_team') }}

),

 stg_fifa_team AS (

select * from {{ ref('stg_fifa_player') }}
)

select stg_player.* 
,stg_team.team_name
from stg_player
inner join stg_team