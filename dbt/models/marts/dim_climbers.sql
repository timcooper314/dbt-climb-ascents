with climbers as (
    select *
    from {{ ref('stg_climbers') }}
),
ascents as (
    select *
    from {{ ref('fct_climber_ascents') }}
),
climbers_ascents as (
    select 
        user_id,
        count(ascent_id) as number_of_ascents,
        min(ascent_date) as first_climb_date,
        max(ascent_date) as most_recent_climb_date,
        max(grade_mean) as max_grade_climb,
        {{ calculate_athena_median('grade_mean') }} as median_grade_climb,
        {{ athena_date_diff_yrs('min(ascent_date)', 'max(ascent_date)') }} as years_climbing
    from ascents
    group by 1
)
select c.user_id,
    c.country,
    c.sex,
    c.height,
    c.weight,
    c.birthdate,
    {{ athena_date_diff_yrs('c.birthdate', 'current_date') }} as age,
    ca.number_of_ascents,
    ca.first_climb_date,
    ca.most_recent_climb_date,
    ca.max_grade_climb,
    ca.median_grade_climb,
    ca.years_climbing
from climbers c
left join climbers_ascents ca
on c.user_id = ca.user_id
