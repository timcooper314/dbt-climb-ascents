with raw_grades_ref as (
    select *
    from {{ ref( 'raw_grades_ref') }}
),

final as (
    select
        grade_id,
        grade_fra
    from raw_grades_ref
)

select *
from final
