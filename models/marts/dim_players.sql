with player as (
    select * from {{ ref('stg_player') }}
)
, team as (
    select * from {{ ref('stg_team') }}
)
, final as (
    select 
        player.player_id
        , player.affiliation_id
        , player.player_name
        , player.weight
        , player.height
        , player.city
        , player.birth_date
        , player.age
        , team.team_name
        , team.country_code
    from player
    left join team on player.affiliation_id = team.affiliation_id
)

select * from final