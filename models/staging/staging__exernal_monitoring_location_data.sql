with 

source as (
    select * from {{ source('staging', 'exernal_monitoring_location_data') }}
),

renamed as (
    select
        cast(site_id as string) as site_id,
        cast(location_description as string) as location_desc,
        cast(borough as string) as borough,
        cast(functional_area_for_monitoring as string) as func_area_monitoring,
        cast(road_type as string) as road_type,
        cast(is_it_on_the_strategic_cio_panel_ as integer) as is_it_on_the_strategic_cio_panel_,
        cast(old_site_id__legacy_ as string) as old_site_id__legacy_,
        cast(easting__uk_grid_ as float64) as easting__uk_grid_,
        cast(northing__uk_grid_ as float64) as northing__uk_grid_,
        cast(latitude as float64) as latitude,
        cast(longitude as float64) as longitude
    from source
)

select * from renamed
