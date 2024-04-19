 -- Creating external table referring to gcs path

   CREATE OR REPLACE EXTERNAL TABLE `majestic-legend-419120.uk_cycling.exernal_central_data`
OPTIONS ( 
  format = 'PARQUET' ,
  uris = ['gs://data_engineering_etido2/uk_cycling_data.parquet', 'gs://data_engineering_etido2/uk_cycling_data.parquet']
);


   CREATE OR REPLACE EXTERNAL TABLE `majestic-legend-419120.uk_cycling.exernal_cycleways_data`
OPTIONS ( 
  format = 'PARQUET' ,
  uris = ['gs://data_engineering_etido2/uk_cycleways.parquet', 'gs://data_engineering_etido2/uk_cycleways.parquet']
);




-- check external central data
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_central_data
LIMIT 10;

SELECT * FROM majestic-legend-419120.uk_cycling.exernal_cycleways_data
LIMIT 10;


-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE majestic-legend-419120.uk_cycling.external_central_non_partitoned AS
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_central_data;

CREATE OR REPLACE TABLE majestic-legend-419120.uk_cycling.external_cycleways_non_partitoned AS
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_cycleways_data;


-- Create a partitioned table from external table
CREATE OR REPLACE TABLE majestic-legend-419120.uk_cycling.external_central_partitoned
PARTITION BY
  DATE(date) AS
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_central_data;

CREATE OR REPLACE TABLE majestic-legend-419120.uk_cycling.external_cycleways_partitoned
PARTITION BY
  DATE(date) AS
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_cycleways_data;

-- Impact of partition
SELECT DISTINCT(unqid)
FROM  majestic-legend-419120.uk_cycling.external_central_non_partitoned
WHERE DATE(date) BETWEEN '2014-01-24' AND '2014-06-30';

SELECT DISTINCT(unqid)
FROM  majestic-legend-419120.uk_cycling.external_cycleways_non_partitoned
WHERE DATE(date) BETWEEN '2014-01-24' AND '2014-06-30';

SELECT DISTINCT(unqid)
FROM  majestic-legend-419120.uk_cycling.external_central_partitoned
WHERE DATE(date) BETWEEN '2014-01-24' AND '2014-06-30';

SELECT DISTINCT(unqid)
FROM  majestic-legend-419120.uk_cycling.external_cycleways_partitoned
WHERE DATE(date) BETWEEN '2014-01-24' AND '2014-06-30';


-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM `uk_cycling.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'external_central_partitoned'
ORDER BY total_rows DESC;


SELECT table_name, partition_id, total_rows
FROM `uk_cycling.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'external_cycleways_partitoned'
ORDER BY total_rows DESC;



--  Drop the existing table
DROP TABLE IF EXISTS majestic-legend-419120.uk_cycling.external_central_partitoned_clustered;




-- Creating a partition and cluster table
CREATE OR REPLACE TABLE majestic-legend-419120.uk_cycling.external_central_partitoned_clustered
PARTITION BY DATE(date)
CLUSTER BY unqid AS
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_central_data;

CREATE OR REPLACE TABLE majestic-legend-419120.uk_cycling.external_cycleways_partitoned_clustered
PARTITION BY DATE(date)
CLUSTER BY unqid AS
SELECT * FROM majestic-legend-419120.uk_cycling.exernal_cycleways_data;



-- Query scans  * GB
SELECT count(*) as trips
FROM majestic-legend-419120.uk_cycling.external_central_partitoned
WHERE DATE(date) BETWEEN '2014-01-01' AND '2015-12-31'
  AND unqid='ML0001';

-- Query scans 294.5 kB
SELECT count(*) as trips
FROM majestic-legend-419120.uk_cycling.external_central_partitoned_clustered
WHERE DATE(date) BETWEEN '2014-01-01' AND '2015-12-31'
  AND unqid='ML0001';
