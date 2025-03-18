{{ config(
  materialized="table"
) }}

with 

source as (

    select * from {{ source('fifa', 'player') }}

),

renamed as (

    select
        id as player_id,
        concat(player_last_name, ' ', player_first_name) as player_name, 
        player_first_name,
        player_middle_name,
        player_last_name,
        player_known_name,
        birth_date,
        weight,
        height,
        city,
        national_team_affiliation_id,
        affiliation_id,
        {{ datediff("birth_date", "'2018-06-14'", "year") }} as age,

    from source

)

select * from renamed
