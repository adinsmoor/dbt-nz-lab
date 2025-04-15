with 

source as (

    select * from {{ source('fifa', 'player') }}

),

renamed as (

    select
        id as player_id,
        concat_ws(' ', player_first_name, player_last_name) as player_name,
        datediff(Year, birth_date, '2018-06-14') as age,
        weight,
        height,
        city,
        national_team_affiliation_id,
        affiliation_id

    from source

)

select * from renamed
