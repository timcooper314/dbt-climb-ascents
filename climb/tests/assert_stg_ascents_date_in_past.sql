with ascents  as (
    select * from {{ ref('stg_ascents') }}
)
select ascent_id,
        ascent_date
from ascents
where ascent_date > current_date
