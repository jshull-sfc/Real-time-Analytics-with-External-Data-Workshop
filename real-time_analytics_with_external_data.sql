--Run ahead of time
USE ROLE SYSADMIN;
CREATE OR REPLACE DATABASE FROSTY_DB;

CREATE OR REPLACE WAREHOUSE WINTER_WH WITH WAREHOUSE_SIZE = 'XXLARGE' WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 600 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 MAX_CLUSTER_COUNT = 2 SCALING_POLICY = 'STANDARD';

create or replace table DAILY_14_TOTAL as
select *
from snowflake_sample_data.weather.DAILY_14_TOTAL;

create or replace table WEATHER_14_TOTAL as
select *
from snowflake_sample_data.weather.WEATHER_14_TOTAL;

--Reset
USE ROLE ACCOUNTADMIN;
DROP SHARE "WEATHER_2019";
DROP MANAGED ACCOUNT "OLAF";

--Start here
create or replace secure view DAILY_14_TOTAL_2019_VW as
select *
from DAILY_14_TOTAL
where t >= to_date('01/01/2019','MM/DD/YYYY');

create or replace secure view WEATHER_14_TOTAL_2019_VW as
select *
from WEATHER_14_TOTAL
where t >= to_date('01/01/2019','MM/DD/YYYY');


