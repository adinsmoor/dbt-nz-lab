with player_events as (
    select
        dp.player_id,
        sum(fe.goals) as total_goals,
        sum(fe.misses) as total_misses,
        sum(fe.cards) as total_cards,
        sum(fe.passes) as total_passes
    from
        {{ ref('dim_players') }} as dp
    inner join
        {{ ref('fct_events') }} as fe
    on
        dp.player_id = fe.player_id
    group by
        dp.player_id
)