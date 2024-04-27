{{
    config(
        materialized='table'
    )
}}

with external_central_partitoned as (
    select *
    from {{ ref('staging__external_central_partitoned') }}
), 
external_cycleways_partitoned as (
    select *
    from {{ ref('staging__external_cycleways_partitoned') }}
), 
trips_unioned as (
    select * from external_central_partitoned
    union all
    select * from external_cycleways_partitoned
),
dim_location as (
    select * from {{ ref('dim_location') }}
)

select 
    trips_unioned.unqid,
    trips_unioned.cycleid,
    trips_unioned.date,
    trips_unioned.time,
    trips_unioned.day,
    trips_unioned.hour,
    trips_unioned.day_of_week,
    trips_unioned.month,
    trips_unioned.cycling_count_description,
    trips_unioned.dir,
    trips_unioned.weather,
    trips_unioned.weather_category,
    monitoring_locations.location_desc,
    monitoring_locations.borough,
    monitoring_locations.func_area_monitoring,
    monitoring_locations.road_type,
    monitoring_locations.easting__uk_grid_,
    monitoring_locations.northing__uk_grid_,
    monitoring_locations.latitude,
    monitoring_locations.longitude,
    trips_unioned.count
from trips_unioned

inner join dim_location as monitoring_locations
on trips_unioned.unqid = monitoring_locations.site_id

order by trips_unioned.date






