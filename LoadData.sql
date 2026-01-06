USE DATABASE my_db;
USE SCHEMA public;

CREATE OR REPLACE TABLE netflix_titles (
  show_id STRING,
  type STRING,
  title STRING,
  director STRING,
  cast STRING,
  country STRING,
  date_added STRING,
  release_year INT,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING,
  first_word STRING,
  year_added INT
);
CREATE OR REPLACE FILE FORMAT csv_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

CREATE OR REPLACE FILE FORMAT csv_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

COPY INTO netflix_titles
FROM @my_stage/cleaned_netflix_titles.csv
FILE_FORMAT = (FORMAT_NAME = csv_format);

SELECT * FROM netflix_titles LIMIT 10;


