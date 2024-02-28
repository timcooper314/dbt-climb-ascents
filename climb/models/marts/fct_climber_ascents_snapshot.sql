with fct_climber_ascents as (
    select * from {{ ref('fct_climber_ascents') }}
),

ordered_ascents as (
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
        climber_age,
        row_number() over (
            partition by user_id
            order by ascent_date asc
        ) as ascent_order,
        max(grade_mean) over (
            partition by user_id
            order by ascent_date asc range between unbounded preceding
            and current row
        ) as hardest_ascent_to_date
    from fct_climber_ascents
)

select * from ordered_ascents
