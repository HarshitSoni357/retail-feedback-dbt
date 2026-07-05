# Retail & Customer Feedback Analytics (dbt + DuckDB)

A local, zero-cost analytics pipeline built on the Olist Brazilian E-Commerce
dataset, modeling order and customer review data end-to-end with dbt-core
and DuckDB, plus a Streamlit dashboard for exploration.

## Stack
- dbt-core + dbt-duckdb
- DuckDB (local file database)
- Streamlit (dashboard)
- Olist Brazilian E-Commerce dataset (Kaggle, free)

## Project structure
- `models/staging/` — cleaned 1:1 views of raw source tables
- `models/marts/` — `fct_orders`, `fct_order_reviews` (business logic, tables)
- `dashboard/app.py` — Streamlit dashboard reading from `dev.duckdb`
- `CLAUDE.md` / `DATA_DICTIONARY.md` / `skills.md` — LLM context files used during development

## Setup
1. `python -m venv dbt-env && source dbt-env/bin/activate`
2. `pip install dbt-duckdb streamlit pandas`
3. Download the Olist dataset from Kaggle into `data/`
4. `dbt deps && dbt build`
5. `streamlit run dashboard/app.py`

## Data note
`review_id` is not globally unique in the raw dataset — some reviews map to
multiple orders. Uniqueness is tested on the (`review_id`, `order_id`) pair
instead of `review_id` alone.