with flattened_locations as (
    {{ flatten_json(
        model_name = source('raw', 'raw_locations'),
        json_column = 'location_data'
    ) }}
)
select location_name,
    longitude::numeric,
    latitude::numeric
from flattened_locations