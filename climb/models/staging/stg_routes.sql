with raw_climbs as (
    select *
    from {{ ref( 'raw_routes') }}
),

final as (
    select
        name_id as route_id,
        country,
        crag,
        sector,
        name,
        tall_recommend_sum,
        grade_mean,
        cluster,
        rating_tot
    from raw_climbs
)

select *
from final
