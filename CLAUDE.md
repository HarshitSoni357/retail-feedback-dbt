# CLAUDE.md

## Project
A local dbt + DuckDB analysis of the Olist Brazilian e‑commerce dataset.
Purpose: reproduce transformations and tests locally with zero cloud cost. Audience: data engineers and analysts exploring or running the project.

## Prerequisites
- Python 3.10+ and a virtualenv (recommended)
- dbt-core and `dbt-duckdb` installed in the project virtualenv
- DuckDB CLI (optional) for ad-hoc queries

## Quick start
1. Create & activate virtualenv:
	- `python -m venv dbt-env`
	- `dbt-env\Scripts\Activate.ps1` (PowerShell) or `dbt-env\Scripts\activate.bat` (cmd)
2. Install dependencies:
	- `pip install -r requirements.txt` (or `pip install dbt-core dbt-duckdb`)
3. Initialize dev DB and run:
	- `dbt debug`
	- `dbt build`
4. View docs:
	- `dbt docs generate`
	- `dbt docs serve` (opens local docs & lineage)

## Sources
- Raw CSVs are read directly via dbt-duckdb's `external_location` in 
  models/staging/sources.yml — no seed/load step required.
    

## Structure
- `data/` — raw CSVs (not tracked in git)
- `models/staging/` — `stg_` models mirroring sources; light cleaning; materialized as views
- `models/marts/` — business logic (`fct_` / `dim_`); materialized as tables
- `seeds/` — small lookup CSVs loaded with `dbt seed`
- `DATA_DICTIONARY.md` — column-level reference for raw source tables
- `skills.md` — modeling conventions and examples

## Conventions
- Every model has an entry in `schema.yml` with `description` and `tests`.
- Naming: `stg_` for staging; `fct_` / `dim_` for marts.
- Use `ref()` and `source()` only — never hardcode table names.
- Prefer `{{ config(materialized='view') }}` for staging, and `table` for marts.
- Run `dbt build` to materialize models and run tests before marking work "done".

## Common Commands
- `dbt debug` — check connection & profile
- `dbt seed` — load seeds
- `dbt run` — compile & run models
- `dbt test` — run tests only
- `dbt build` — run + test together (recommended CI workflow)
- `dbt docs generate && dbt docs serve` — generate and serve docs

## Database / local dev
- Local DB file: `dev.duckdb` (gitignored) in the project root.
- Query with DuckDB CLI: `duckdb dev.duckdb`
- Profile: uses profile `retail_feedback` in `~/.dbt/profiles.yml` pointing to `dev.duckdb`.

## Notes & tips
- Use `dbt run --select <model>` for iterative development.
- Add tests to `schema.yml` for critical business logic (uniqueness, relationships, not_null).

