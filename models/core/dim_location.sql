{{ config(materialized='table') }}

select 
    site_id, 
    location_desc,
    borough, 
    func_area_monitoring, 
    road_type,
    easting__uk_grid_,
    northing__uk_grid_,
    latitude,
    longitude
from {{ ref('staging__exernal_monitoring_location_data') }}