with routes as (
    select *
    from {{ ref('stg_routes') }}
),
climbers as (
    select *
    from {{ ref('stg_climbers') }}
),
ascents as (
    select *
    from {{ ref('stg_ascents') }}
),
grades_reference as (
    select *
    from {{ ref('stg_grades_ref') }}
),
route_details as (
    select routes.route_id,
        routes.name as route_name,
        routes.crag as crag,
        routes.sector as sector,
        routes.country as country,
        routes.grade_mean as grade_mean,
        g_ref.grade_id as grade_id,
        g_ref.grade_fra as grade_fra
    from routes
        left join grades_reference as g_ref on round(routes.grade_mean) = g_ref.grade_id
),
climbers_ascents as (
    select ascents.ascent_id,
        ascents.user_id,
        ascents.route_id,
        ascents.ascent_date,
        route_details.route_name,
        route_details.crag,
        route_details.sector,
        route_details.country,
        route_details.grade_mean,
        route_details.grade_id,
        route_details.grade_fra,
        {{ athena_date_diff_yrs(
            'climbers.birthdate',
            'ascents.ascent_date'
        ) }} as climber_age
    from ascents
        left join climbers on ascents.user_id = climbers.user_id
        left join route_details on ascents.route_id = route_details.route_id
),
final as (
    select ascent_id,
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
    from climbers_ascents
)
select *
from final