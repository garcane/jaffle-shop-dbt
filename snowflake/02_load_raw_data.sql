-- Loads the CSVs in snowflake/data/ into the RAW tables created by 01_create_raw_database.sql.
-- Run from the repository root with SnowSQL (PUT is not supported in the Snowsight web UI):
--   snowsql -f snowflake/02_load_raw_data.sql
--
-- The _ETL_LOADED_AT / _BATCHED_AT columns are intentionally left out of the CSVs;
-- their DEFAULT CURRENT_TIMESTAMP() fills them at load time, so source freshness checks start green.

create stage if not exists RAW.PUBLIC.RAW_DATA_STAGE
    file_format = (type = csv skip_header = 1 field_optionally_enclosed_by = '"');

put file://snowflake/data/jaffle_shop_customers.csv @RAW.PUBLIC.RAW_DATA_STAGE auto_compress = false overwrite = true;
put file://snowflake/data/jaffle_shop_orders.csv    @RAW.PUBLIC.RAW_DATA_STAGE auto_compress = false overwrite = true;
put file://snowflake/data/stripe_payment.csv        @RAW.PUBLIC.RAW_DATA_STAGE auto_compress = false overwrite = true;

truncate table if exists RAW.JAFFLE_SHOP.CUSTOMERS;
truncate table if exists RAW.JAFFLE_SHOP.ORDERS;
truncate table if exists RAW.STRIPE.PAYMENT;

copy into RAW.JAFFLE_SHOP.CUSTOMERS (ID, FIRST_NAME, LAST_NAME)
    from @RAW.PUBLIC.RAW_DATA_STAGE/jaffle_shop_customers.csv;

copy into RAW.JAFFLE_SHOP.ORDERS (ID, USER_ID, ORDER_DATE, STATUS)
    from @RAW.PUBLIC.RAW_DATA_STAGE/jaffle_shop_orders.csv;

copy into RAW.STRIPE.PAYMENT (ID, ORDERID, PAYMENTMETHOD, STATUS, AMOUNT, CREATED)
    from @RAW.PUBLIC.RAW_DATA_STAGE/stripe_payment.csv;

-- Sanity check: expect 100, 99 and 120 rows.
select 'customers' as table_name, count(*) as row_count from RAW.JAFFLE_SHOP.CUSTOMERS
union all select 'orders', count(*) from RAW.JAFFLE_SHOP.ORDERS
union all select 'payment', count(*) from RAW.STRIPE.PAYMENT;
