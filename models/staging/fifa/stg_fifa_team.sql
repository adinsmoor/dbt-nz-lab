with 

source as (

    select * from {{ source('fifa', 'team') }}

),

renamed as (

    select
        id as player_id,
        name as team_name,
        name_short,
        affiliation_id

    from source

)

select * from renamed
