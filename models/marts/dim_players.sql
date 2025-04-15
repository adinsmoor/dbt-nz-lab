
select 
    p.*,
    t.team_name,
    t.country_code
from 
    {{ ref('stg_player') }} as p
inner join 
    {{ ref('stg_team') }} as t
on 
    p.affiliation_id = t.affiliation_id