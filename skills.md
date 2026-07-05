# skills.md — Modeling Conventions

## Purpose
This document defines the local dbt modeling conventions for the retail feedback project. It keeps staging models focused on raw data cleanup and marts focused on business logic, while enforcing consistent naming and test coverage.

## Naming
- Staging models: `stg_<source_table_short_name>.sql` (e.g. `stg_orders`, `stg_order_reviews`)
- Mart models: `fct_<subject>.sql` for facts, `dim_<subject>.sql` for dimensions
- Use `ref()` for all model dependencies; avoid hardcoded table names.

## Staging model pattern
- One staging model per raw source table.
- Use staging for:
  - raw column renaming
  - type casting and normalization
  - simple value lookups or translation joins
  - basic data cleaning and metadata derivation
- Do not use staging for:
  - business logic or domain filtering
  - aggregation
  - broad joins across unrelated entities
- Materialization: views, configured globally in `dbt_project.yml`.

Example staging model (`models/staging/stg_order_reviews.sql`):
```sql
select
    review_id,
    order_id,
    cast(review_score as integer) as review_score,
    review_comment_title,
    review_comment_message,
    cast(review_creation_date as timestamp) as reviewed_at
from {{ source('raw', 'olist_order_reviews_dataset') }}
```

## Mart model pattern
- Core marts (fct_/dim_) are built from staging models only; use ref('stg_...').
- Summary/aggregate marts (no fct_/dim_ prefix, e.g. customer_satisfaction) 
  may reference other marts via ref('fct_...') to avoid recomputing logic 
  that already exists downstream.

Example mart model snippet:
```sql
with reviews as (
    select * from {{ ref('stg_order_reviews') }}
), orders as (
    select * from {{ ref('stg_orders') }}
)
select
    o.order_id,
    r.review_score,
    r.reviewed_at
from orders o
join reviews r using (order_id)
```

## Testing conventions
- Every primary key should have `not_null` and `unique` tests.
- Every foreign key should use a `relationships` test against the parent model.
- Use `accepted_values` for bounded or categorical fields such as `review_score`.
- Add tests for critical business logic and data quality assumptions.
- Prefer focused validation during development with `dbt test --select <model>`.

Example `schema.yml` tests:
```yaml
models:
  - name: stg_order_reviews
    columns:
      - name: review_id
        tests:
          - not_null
          - unique
      - name: review_score
        tests:
          - not_null
          - accepted_values:
              values: [1, 2, 3, 4, 5]

  - name: fct_order_reviews
    columns:
      - name: order_id
        tests:
          - not_null
          - relationships:
              to: ref('stg_orders')
              field: order_id
```

## Commands
- `dbt run --select staging` — build only the staging layer
- `dbt build` — run models and tests together
- `dbt docs generate && dbt docs serve` — generate and serve docs and lineage
- `dbt run --select <model>` — iterate on a single model quickly
- `dbt test --select <model>` — validate one model or model group

## Why this matters
- Staging as views keeps raw cleanup transparent and easy to debug.
- Marts as tables keep business logic stable and performant.
- Consistent naming and tests improve collaboration and reduce surprises.

## Current Model Schemas (post-transformation)

stg_orders: order_id, customer_id, order_status, ordered_at, delivered_at
stg_order_items: order_id, order_item_id, product_id, price, freight_value
stg_order_reviews: review_id, order_id, review_score, review_comment_title, 
                    review_comment_message, reviewed_at
                    ⚠️ no customer_id — must join to stg_orders/fct_orders on order_id
stg_products: product_id, product_category
stg_customers: customer_id, customer_unique_id, customer_city, customer_state

fct_orders: order_id, customer_id, order_status, ordered_at, delivered_at, 
            item_count, order_value, freight_total
fct_order_reviews: review_id, order_id, customer_id, review_score, 
                    reviewed_at, is_positive_review

## LLM Output Review Checklist
Before running any LLM-generated model:
1. Does every column referenced actually exist in the source model? (check against DATA_DICTIONARY.md)
2. Are all ref()/source() calls pointing to real, existing models?
3. If there's a join after an aggregation — does it re-aggregate, or does it fan out?
4. Does the metric's denominator match its numerator's grain? (e.g. reviews/reviews, not reviews/orders)
5. Run `dbt compile` before `dbt run`.
