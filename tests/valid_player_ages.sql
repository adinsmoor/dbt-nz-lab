select * from {{ ref('dim_players') }}
where age < 18 or age > 36