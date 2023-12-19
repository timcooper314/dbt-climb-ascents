with routes as (
    select *
    from {{ ref ('stg_routes') }}
)
select country,
    count(route_id) as num_routes,
    count(distinct crag) as num_crags,
    count(distinct sector) as num_sectors,
    max(grade_mean) as hardest_route_grade,
    {{ calculate_median('grade_mean') }} as median_route_grade,
    avg(rating_tot) as avg_route_rating
from routes
group by 1