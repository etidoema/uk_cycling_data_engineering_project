{{
    config(
        materialized='view'
    )
}}

with cyclingdata as 
(
  select *,
    row_number() over(partition by unqid, date) as dn
  from {{ source('staging','external_cycleways_partitoned') }}
  where unqid is not null 
)

    select

    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['unqid', 'date']) }} as cycleid,
    cast(unqid as string) as unqid,

    -- timestamps
      cast(date as timestamp) as date,
      cast(time as timestamp) as time,

    -- cycle info
      cast(count as integer) as count,
      {{ get_cycling_count_description('count') }} as cycling_count_description,
      cast(round as string) as round,
      cast(dir as string) as dir,
      cast(path as string) as path,
      cast(mode as string) as mode,

      -- period  
      cast(year as string) as year,
      cast(day as string) as day,
      cast(hour as integer) as hour,
      cast(day_of_week as integer) as day_of_week,
      cast(month as integer) as month,

      --  Weather conditions
      cast(weather as string) as weather,
      cast(weather_category as string) as weather_category,
      
      cast(__index_level_0__ as integer) as __index_level_0__
    from cyclingdata
    


