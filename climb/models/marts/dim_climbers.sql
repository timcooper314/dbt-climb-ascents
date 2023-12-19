with climbers as (
    select *
    from {{ ref('stg_climbers') }}
),
ascents as (
    select *
    from {{ ref('fct_climber_ascents') }}
),
climbers_climbs as (
    select user_id,
        count(ascent_id) as number_of_ascents,
        min(ascent_date) as first_climb_date,
        max(ascent_date) as most_recent_climb_date,
        max(grade_mean) as max_grade_climb,
        {{ calculate_median('grade_mean') }} as median_grade_climb,
        {{ datediff('min(ascent_date)', 'max(ascent_date)', "year") }} as years_climbing
    from ascents
    group by 1
)
select user_id,
    number_of_ascents,
    first_climb_date,
    most_recent_climb_date,
    max_grade_climb,
    median_grade_climb,
    years_climbing
from climbers_climbs