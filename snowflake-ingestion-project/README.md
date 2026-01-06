# Snowflake Ingestion Project

This project shows how to put data (CSV and JSON files) into Snowflake, store them in a stage, and then load them into tables.  

---

## 📂 Project Files

- `sales.csv` → Example sales data in CSV format  
- `events.json` → Example events data in JSON format  
- `snowflake_ingestion.sql` → One SQL script that sets up everything and loads the data  
- `README.md` → This guide  

---

## 🚀 How to Use

1. **Open Snowflake**
   - Log in to Snowflake (web or SnowSQL).

2. **Upload files into stage**
   - Use SnowSQL to put files into the stage:
     ```bash
     PUT file://sales.csv @retail_db.sales.raw_internal AUTO_COMPRESS=TRUE;
     PUT file://events.json @retail_db.sales.raw_internal AUTO_COMPRESS=TRUE;
     ```
   - Check if files are there:
     ```sql
     LIST @retail_db.sales.raw_internal;
     ```

3. **Run the SQL script**
   - Run `snowflake_ingestion.sql` in Snowflake.
   - This script will:
     - Create stage and file formats  
     - Create tables (`sales`, `events`, `parquet_sales`)  
     - Load data from the stage into tables  
     - Show some sample queries  

4. **See the data**
   - Look at sales data:
     ```sql
     SELECT * FROM sales LIMIT 10;
     ```
   - Look at events data:
     ```sql
     SELECT 
       event:event_type::string   AS event_type,
       event:customer_id::int     AS customer_id,
       event:timestamp::timestamp AS ts,
       event:amount::float        AS amount
     FROM events;
     ```

---

## ✅ What You Learn

- How to create a stage in Snowflake  
- How to define file formats (CSV, JSON, Parquet)  
- How to load files into tables using `COPY INTO`  
- How to query JSON data stored in a VARIANT column  

---

## 📖 Summary

This is a simple project to practice loading files into Snowflake.  
You upload files into a stage, run the SQL script, and then query the tables to see the data.
