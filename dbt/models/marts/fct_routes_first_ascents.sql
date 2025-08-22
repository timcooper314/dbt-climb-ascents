with fct_climber_ascents as (
    select * from {{ ref('fct_climber_ascents') }}
),

route_ascensions_order as (
    select
        *,
        row_number() over (
            partition by route_id
            order by ascent_date asc
        ) as ascension_order
    from fct_climber_ascents
)

select
    ascent_id,
    user_id,
    route_id,
    ascent_date,
    route_name,
    crag,
    sector,
    country,
    grade_mean,
    grade_id,
    grade_fra,
    climber_age
from route_ascensions_order
where ascension_order = 1
