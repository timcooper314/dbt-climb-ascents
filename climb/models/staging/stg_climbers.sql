with raw_climbers as (
    select *
    from {{ source('raw', 'raw_climbers') }}
),
final as (
    select user_id,
        country,
        sex,
        height,
        weight,
        to_date(cast(birthdate as varchar), 'YYYY-MM-DD') as birthdate
    from raw_climbers
)
select *
from final