{{
    config(
        severity = 'warn',
        error_if = '> 10'
    )
}}
SELECT 
    *
FROM 
    {{ ref('dim_players') }}
WHERE 
    age < 18 OR age > 36