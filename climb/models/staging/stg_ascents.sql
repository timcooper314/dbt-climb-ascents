with raw_ascents as (
    select *
    from {{ ref( 'raw_ascents') }}
),

final as (
    select
        ascent_id,
        user_id,
        route_id,
        ascent_date
    from raw_ascents
)

select *
from final
