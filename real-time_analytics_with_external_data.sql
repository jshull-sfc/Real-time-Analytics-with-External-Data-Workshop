--Set up
USE ROLE ACCOUNTADMIN; --Highest level access for this URL
DROP DATABASE IF EXISTS DEMO_WEATHERSOURCE; --Clean up
DROP SHARE IF EXISTS "WEATHER_2016";        --Clean up
DROP MANAGED ACCOUNT IF EXISTS "OLAF";      --Clean up
USE ROLE SYSADMIN; --Change to lower privileged DBA role
CREATE OR REPLACE DATABASE FROSTY_DB;  --Create Database

CREATE OR REPLACE WAREHOUSE WINTER_WH WITH WAREHOUSE_SIZE = 'MEDIUM' WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 600 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 MAX_CLUSTER_COUNT = 2 SCALING_POLICY = 'STANDARD'; --Create virtual compute warehouse

/*
1. Go out to the Data Marketplace.
2. Search for Weather Source.
3. Select Weather Source - Global Weather & Climate Data for BI.
4. Get the data and name the Database DEMO_WEATHERSOURCE.
5. Leave the default permissions for SYSADMIN.

How many Deliveries will be delayed due to snowfall?

When it snows in excess of 6 inches per day, my company experiences delivery delays.
How many deliveries may have been delayed?
*/

SELECT   COUNTRY,
         POSTAL_CODE,
         DATE_VALID_STD,
         TOT_SNOWFALL_IN 
FROM     DEMO_WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY
WHERE    COUNTRY='US'
AND      TOT_SNOWFALL_IN > 6.0 
ORDER BY POSTAL_CODE, DATE_VALID_STD
LIMIT 10;

-- Create a table for snowfall greater than 6 inches.
CREATE OR REPLACE TABLE FROSTY_DB.PUBLIC.HISTORY_DAY as
SELECT   COUNTRY,
         POSTAL_CODE,
         DATE_VALID_STD,
         TOT_SNOWFALL_IN 
FROM     DEMO_WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY
WHERE    COUNTRY='US'
AND      TOT_SNOWFALL_IN > 6.0 
ORDER BY POSTAL_CODE, DATE_VALID_STD;

--Follow documentation to create reader account in the Web UI.

--Start here unless you do not have time to wait for the new URL to be active. Then you could complete everything ahead of time.
use database frosty_db;
use warehouse WINTER_WH;

CREATE OR REPLACE SECURE VIEW FROSTY_DB.PUBLIC.HISTORY_DAY_SVW as
SELECT *
FROM FROSTY_DB.PUBLIC.HISTORY_DAY;
