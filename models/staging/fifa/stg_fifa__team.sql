with 

source as (

    select * from {{ source('fifa', 'team') }}

),

renamed as (

    select
        id,
        name,
        name_official,
        name_short,
        symid,
        affiliation_id

    from source

)

select * from renamed
