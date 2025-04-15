{{
 config(
 severity = 'warn',
 error_if = '>10'
 )
}}

SELECT
    player_id
    , player_name
    , age
FROM
    {{ ref('dim_players') }}
WHERE age < 18 OR age > 36
