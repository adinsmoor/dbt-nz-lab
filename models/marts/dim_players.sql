with player_team as (
    select
        p.*,
        t.*
    from
        {{ ref('stg_fifa_player') }} as p
    inner join
        {{ ref('stg_team') }} as t
        on
            p.affiliation_id = t.affiliation_id
)

select * from player_team
