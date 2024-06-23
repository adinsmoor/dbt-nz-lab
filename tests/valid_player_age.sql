{{
    config(
        severity = 'warn',
        error_if = '>10'
    )
}}

select
* from {{ ref('dim_players') }}
WHERE age < 18 OR age > 36