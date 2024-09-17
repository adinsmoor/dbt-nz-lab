with
player as (select * from {{ ref('stg_player') }}),

teams as (select * from {{ ref('stg_team') }}),

player_teams as (
    select
        player.*,
        teams.team_name,
        team.country_code
    from
        player
    left join teams
        on player.affiliation_id = teams.affiliation_id
)

select * from player_teams
