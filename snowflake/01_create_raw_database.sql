-- Recreates the RAW Snowflake database that feeds the Jaffle Shop dbt project.
-- Extracted with GET_DDL('database', 'RAW') from the original account.
-- Run this first, then 02_load_raw_data.sql.

create database if not exists RAW;

create schema if not exists RAW.JAFFLE_SHOP;
create schema if not exists RAW.STRIPE;
create schema if not exists RAW.PUBLIC;

create table if not exists RAW.JAFFLE_SHOP.CUSTOMERS (
    ID NUMBER(38,0),
    FIRST_NAME VARCHAR(16777216),
    LAST_NAME VARCHAR(16777216)
);

create table if not exists RAW.JAFFLE_SHOP.ORDERS (
    ID NUMBER(38,0),
    USER_ID NUMBER(38,0),
    ORDER_DATE DATE,
    STATUS VARCHAR(16777216),
    _ETL_LOADED_AT TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);

create table if not exists RAW.STRIPE.PAYMENT (
    ID NUMBER(38,0),
    ORDERID NUMBER(38,0),
    PAYMENTMETHOD VARCHAR(16777216),
    STATUS VARCHAR(16777216),
    AMOUNT NUMBER(38,0),
    CREATED DATE,
    _BATCHED_AT TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
