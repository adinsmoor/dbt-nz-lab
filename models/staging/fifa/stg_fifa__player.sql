{{
    config(
        materialized='table'
    )
}}
with 

source as (

    select * from {{ source('fifa', 'player') }}

),

renamed as (

    select
        id as player_id,
        CONCAT(player_first_name, ' ', player_last_name) AS player_name,
        DATEDIFF(YEAR, birth_date, '2018-06-14') AS AGE,
        player_first_name,
        player_middle_name,
        player_last_name,
        player_known_name,
        birth_date,
        weight,
        height,
        city,
        national_team_affiliation_id,
        affiliation_id
    from source

)

select * from renamed
