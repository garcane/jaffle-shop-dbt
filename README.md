# Jaffle Shop dbt project

Staging and mart models for the Jaffle Shop sample data (customers, orders and Stripe payments), built with dbt on Snowflake. Migrated from a dbt Cloud managed repository, together with the raw Snowflake data that feeds it, so the repo is self-contained.

## Layout

| Path | What it holds |
|------|---------------|
| `models/staging/jaffle_shop`, `models/staging/stripe` | Source definitions, staging models, tests and docs blocks |
| `models/marts` | `dim_customers` and `finance/fct_orders` |
| `tests/` | Singular test: payment totals must not be negative |
| `snowflake/01_create_raw_database.sql` | DDL for the `RAW` database (schemas `JAFFLE_SHOP`, `STRIPE`, `PUBLIC`) |
| `snowflake/02_load_raw_data.sql` | SnowSQL script that stages and loads the CSVs |
| `snowflake/data/` | Raw data: 100 customers, 99 orders, 120 payments |

## Rebuilding from scratch

1. Run `snowflake/01_create_raw_database.sql` in Snowflake to create the `RAW` database and tables.
2. From the repo root, run `snowsql -f snowflake/02_load_raw_data.sql` to load the CSVs. It ends with a row-count check (100 / 99 / 120).
3. Point dbt at your Snowflake account. Create a `profiles.yml` for the profile named `default` (see `dbt_project.yml`); it is not stored in this repo.
4. Run `dbt deps` then `dbt build`.

## Notes

- Sources read from `raw.jaffle_shop` and `raw.stripe`.
- `_ETL_LOADED_AT` and `_BATCHED_AT` are not in the CSVs; Snowflake fills them with the load time.
- Credentials are never stored in this repo.
