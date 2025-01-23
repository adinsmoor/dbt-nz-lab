{{
    config(
        error_if='>10'
    )
}}

WITH dim_players AS (
    SELECT * FROM {{ ref('dim_players') }}
)

SELECT *
FROM dim_players
WHERE age < 18 AND age > 36
