# Mage

## Getting Started
To start Mage, navigate to the Mage directory and launch it using Docker.

### Instructions
1. **Navigate to the Mage Directory**: Open your terminal and change directory to the location where Mage is installed.
   
2. **Launch Mage with Docker**: Use Docker to start Mage. i will use the following command: docker compose up

 ## Opening Mage and Creating a New ETL Pipeline

To begin working with Mage, you'll need to open it in your web browser and create a new ETL pipeline.

### Instructions
1. **Open Mage**: Open your web browser and navigate to `localhost:6789`.

2. **Navigate to Pipelines**: Once logged in, navigate to the ETL pipelines section of Mage.

3. **Create a New Pipeline**: Look for an option to create a new ETL pipeline and follow the prompts to set it up according to your requirements.


## Extraction block :

```python
import io
import pandas as pd
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    urls = [
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2014%20Q1%20(Jan-Mar)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2014%20Q2%20spring%20(Apr-Jun)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2014%20Q3%20(Jul-Sep)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2014%20Q4%20autumn%20(Oct-Dec)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2015%20Q1%20(Jan-Mar)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2015%20Q2%20spring%20(Apr-Jun)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2015%20Q3%20(Jul-Sep)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2015%20Q4%20autumn%20(Oct-Dec)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2016%20Q1%20(Jan-Mar)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2016%20Q2%20spring%20(Apr-Jun)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2016%20Q3%20(Jul-Sep)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2016%20Q4%20autumn%20(Oct-Dec)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2017%20Q1%20(Jan-Mar)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2017%20Q2%20spring%20(Apr-Jun)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2017%20Q3%20(Jul-Sep)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2017%20Q4%20autumn%20(Oct-Dec)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2018%20Q1%20(Jan-Mar)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2018%20Q2%20spring%20(Apr-Jun)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2018%20Q3%20(Jul-Sep)-Central.csv',
        'https://cycling.data.tfl.gov.uk/ActiveTravelCountsProgramme/2018%20Q4%20autumn%20(Oct-Dec)-Central.csv'

    ]

    # Define the data types for each column
    cycling_dtypes = {
        'UnqID': 'object',
        'Weather': 'category',
        'Round': 'object',
        'Dir': 'category',
        'Path': 'object',
        'Mode': 'category',
        'Count': 'int64'
    }

    parse_dates = ['Time', 'Date']  # Ensure this matches the actual column name in your CSV files

    # Read CSV data
    df_list = [pd.read_csv(io.StringIO(requests.get(url).text), sep=",", dtype=cycling_dtypes, parse_dates=parse_dates) for url in urls]

    # Concatenate DataFrames
    df_combine = pd.concat(df_list, ignore_index=True)

    # Parse dates with specific format
    df_combine['Date'] = pd.to_datetime(df_combine['Date'], format='%d/%m/%Y')

    return df_combine

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

```

## Transformation block:

```python
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

import pandas as pd    

@transformer
def transform(data, *args, **kwargs):

# Step  1: Remove rows where passenger count is  0 or trip distance is  0
    #data = data[(data['passenger_count'] !=  0) & (data['trip_distance'] !=  0)] 

# Step  2: Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date
    #data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

#Step  3: Rename columns in CamelCase to snake_case (Column_name srandardization)
    data.rename(columns=lambda x: x.lower().replace(" ", "_"), inplace=True)

# Convert 'Date' column to datetime
    data['date'] = pd.to_datetime(data['date'], format='%d/%m/%Y')

# Extract additional features
    data['hour'] = pd.to_datetime(data['time']).dt.hour
    data['day_of_week'] = data['date'].dt.dayofweek  # Monday=0, Sunday=6
    data['month'] = data['date'].dt.month

    unique_values_weather = data['weather'].unique()
    #print("Unique values in column 'weather':", unique_values_weather)
    
    print("Rows with zero cycling count :" ,  data['count'].isin([0]).sum())

# Define categories
    categories = {
    'Dry': ['Dry', 'Almost Dry', 'Dry & Sunny', 'Dry Wet Road', 'Dry/wet', 'Dry & Wet', 'Dry A.m Wet P.m',
            'Dry/sunny', 'Dry/cloudy', 'Dry/hot', 'Very Hot Dry', 'Dry Dark', 'Dark Dry', 'Dry Mon', 'Dry Wed',
            'Dry Thu', 'Dry Fri', 'Dry Y', 'Good/dry', 'Dry/good'],
    'Wet': ['Wet', 'Slightly Wet', 'Wet Damp', 'Very Wet', 'V Wet', 'Wet - Dry', 'Dry - Wet', 'Wet/ Dry', 'S. Wet',
            'V. Wet', 'Wet Intermittently', 'Wet T', 'Wet & Windy', 'Wet & Very Windy', 'Wet Road', 'Wetish'],
    'Rain': ['Rain', 'Light Rain', 'Rain Stopped', 'Rain Damp', 'Rain Dry', 'Light Shower', 'Showers', 'Lt Rain',
            'Showers', 'Slight Drizzle', 'Very Heavy Rain', 'Rain/wind', 'Fine Drizzle', 'Rainy', 'Rain/dry',
            'Showers Mix', 'Rains', 'Sun/rain', 'Rain/dry', 'Occasional Lt Snow Shrs'],
    'Fine': ['Fine', 'Fine Windy', 'Fine (windy)', 'Fine Drizzle'],
    'Damp': ['Damp', 'Damp - Rain', 'Wet/dry', 'Damp - Rain'],
    'Cloudy': ['Cloudy', 'Cloudy/ Rain', 'Partly Cloudy', 'Sunny Cloudy'],
    'Foggy': ['Foggy'],
    'Drizzle': ['Drizzle', 'Slight Drizzle', 'Fine Drizzle'],
    'Showery': ['Showery', 'Light Showers', 'Heavy Showers'],
    'Other': ['Cold/rain', 'Cold/ Rain', 'Cold Windy Dry', 'Drty', 'Dry (windy)', 'Down Pour', 'Mist',
              'Road Drying Sun Out', 'Dark', 'Dark Sunny', 'Dark', 'Mild', 'Dryish', 'Light Shrs', 'Some Showers',
              'Dry & Windy', 'Dry Windy', 'Deluge', 'Dry & Very Windy', 'Windy', 'Windy/ Rain', 'Blustery', 'Cold',
              'Down Pour', 'Hazy', 'Kdry', 'Wet (windy)', 'Fine (windy)', 'Road Drying Sun Out', 'Wet (windy)', 'Dryish',
              'Light Shrs', 'Some Showers', 'Drizzle', 'Slight Drizzle', 'Fine Drizzle', 'Heavy Showers',
              'Wet + Windy', 'Wet & Windy', 'Rain/wind', 'Cold Windy Dry']
}

    # Map categories to values
    data['weather_Category'] = data['weather'].apply(lambda x: next((k for k, v in categories.items() if x in v), 'Other'))

    return data[data['count'] > 0]

@test
def test_output(output, *args):
    assert output['count'].isin([0]).sum() == 0, 'There are cycling with zero count'


```

## Export Block :
```python
from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

@data_exporter
def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    bucket_name = 'data_engineering_etido2'
    object_key = 'uk_cycling_data.parquet'

    GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        bucket_name,
        object_key,
    )
```

The data has been exported to google cloud and also partitioned by day.

