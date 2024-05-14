with count_pos as (
    select * from {{ ref("staging__external_central_partitoned")}}
)

select unqid, sum(count) as total_rides
from count_pos

group by 1
having total_rides < 0

,

