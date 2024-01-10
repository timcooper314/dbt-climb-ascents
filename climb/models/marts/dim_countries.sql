with routes as (
    select *
    from {{ ref ('stg_routes') }}
),
grades_ref as (
    select * from {{ ref('stg_grades_ref')}}
),
country_stats as (
    select r.country,
        count(r.route_id) as num_routes,
        count(distinct r.crag) as num_crags,
        count(distinct r.sector) as num_sectors,
        max(r.grade_mean) as hardest_route_grade,
        {{ calculate_athena_median('r.grade_mean') }} as median_route_grade,
        avg(rating_tot) as avg_route_rating
    from routes r
    group by 1
),
country_stats_with_fra as (
    select 
        cs.country,
        cs.num_routes,
        cs.num_crags,
        cs.num_sectors,
        cs.hardest_route_grade,
        g_ref_hard.grade_fra as hardest_route_grade_fra,
        cs.median_route_grade,
        g_ref_med.grade_fra as median_route_grade_fra,
        cs.avg_route_rating
    from country_stats cs
		left join grades_ref g_ref_hard 
		on round(cs.hardest_route_grade) = g_ref_hard.grade_id
		left join grades_ref g_ref_med
		on round(cs.median_route_grade) = g_ref_med.grade_id
)
select * from country_stats_with_fra
