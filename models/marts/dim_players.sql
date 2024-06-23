with player as (
    select * from {{ ref('stg_player') }}
),
team as (
    select * from {{ ref('stg_team') }}
),
final as (
    select 
        player.*,
        team.team_name,
        team.country_code
    from player left join team on player.affiliation_id = team.affiliation_id
)

select * from final