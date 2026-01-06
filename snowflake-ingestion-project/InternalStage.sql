-- ============================================================
-- Snowflake Ingestion Project: CSV + JSON + PARQUET
-- This script sets up database, schema, stage, file formats,
-- tables, loads data, and runs verification queries.
-- ============================================================

-- Step 1: Set context (database + schema)
USE DATABASE retail_db;
USE SCHEMA sales;

-- Step 2: Create a named internal stage
-- A stage is a temporary storage area for files before loading.
CREATE OR REPLACE STAGE raw_internal;

-- Step 3: Define file formats for different file types
-- CSV format: skip header row, allow quoted fields
CREATE OR REPLACE FILE FORMAT csv_sales 
  TYPE = CSV 
  FIELD_OPTIONALLY_ENCLOSED_BY = '"' 
  SKIP_HEADER = 1;

-- JSON format: default settings
CREATE OR REPLACE FILE FORMAT json_events 
  TYPE = JSON;

-- Parquet format: default settings
CREATE OR REPLACE FILE FORMAT parquet_data 
  TYPE = PARQUET;

-- Step 4: Create target tables
-- Structured sales table for CSV data
CREATE OR REPLACE TABLE sales (
  order_id INT,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount NUMBER(10,2)
);

-- Semi-structured events table for JSON data
CREATE OR REPLACE TABLE events (
  event VARIANT
);

-- Parquet sales table for Parquet data
CREATE OR REPLACE TABLE parquet_sales (
  order_id INT,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount NUMBER(10,2)
);

-- Step 5: Load data from stage into tables
-- Load CSV file into sales table
COPY INTO sales
FROM @retail_db.sales.raw_internal/sales.csv
FILE_FORMAT = (FORMAT_NAME = retail_db.sales.csv_sales)
ON_ERROR = 'CONTINUE';  -- skip bad rows, load the rest

-- Load JSON file into events table
COPY INTO events
FROM @retail_db.sales.raw_internal/events.json.gz
FILE_FORMAT = (TYPE = JSON)
ON_ERROR = 'CONTINUE';

-- Step 6: Verification queries
-- Preview first 10 rows of sales table
SELECT * FROM sales LIMIT 10;

-- Extract fields from JSON VARIANT column in events table
SELECT 
  event:event_type::string AS event_type, 
  event:customer_id::int   AS customer_id
FROM events;

-- Step 7: Stage inspection
-- List all files currently in the stage
LIST @retail_db.sales.raw_internal;

-- Preview raw JSON file directly from stage
SELECT $1
FROM @retail_db.sales.raw_internal/events.json
(FILE_FORMAT => retail_db.sales.json_events)
LIMIT 5;

-- Step 8: Extended JSON query
-- Extract multiple fields from JSON events
SELECT 
  event:event_type::string   AS event_type,
  event:customer_id::int     AS customer_id,
  event:timestamp::timestamp AS ts,
  event:amount::float        AS amount
FROM events;
