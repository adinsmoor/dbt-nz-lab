{{
    config(
        severity = 'warn',
        error_if = '>10'
    )
}}

select * from {{ ref('dim_players') }} as p
where (p.age < 18 or p.age > 36)
