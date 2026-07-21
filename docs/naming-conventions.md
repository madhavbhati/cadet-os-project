# CadetOS Data Warehouse Naming Conventions

To maintain readability and consistency across all layers of the Medallion pipeline, the following naming standards are enforced:

---

## 1. Database Names
Databases are named using a standard snake_case format prefixing the warehouse layer:
*   Bronze Raw Layer: `cadetos_bronze`
*   Silver Cleaned Layer: `cadetos_silver`
*   Gold Star Schema Layer: `cadetos_gold`

---

## 2. Table Names
Tables are named in lowercase snake_case, using distinct prefixes in the Gold layer to distinguish between dimensions, facts, and aggregate summaries:
*   **Dimensions**: Prefix `dim_` (e.g. `dim_cadet`, `dim_date`, `dim_rank`).
*   **Facts**: Prefix `fct_` (e.g. `fct_attendance`, `fct_rank_assignment`).
*   **Aggregates / Summary**: Prefix `agg_` (e.g. `agg_unit_summary`, `agg_cadet_annual_metrics`).

---

## 3. Column Names
Standard lower snake_case formatting is applied across all columns:
*   Primary Keys (PK): Named `[entity]_id` in dimensions (e.g. `cadet_id`, `rank_id`), or as standard numeric IDs in transactional tables (e.g. `attendance_id`).
*   Foreign Keys (FK): Match the PK name of the dimension table they reference (e.g. `cadet_id` in `fct_attendance`).
*   Boolean Indicators: Prefix `is_` (e.g. `is_active`, `is_weekend`, `is_passed`).
*   Timestamps and Dates: Suffix `_date` (e.g. `joining_date`, `assigned_date`, `parade_date`) and are stored as native `DATE` types.
*   Date Keys: Suffix `_date_id` (e.g. `parade_date_id`) referencing the calendar dimension using `YYYYMMDD` integers.

---

## 4. SQL File Names
Scripts are named in lowercase snake_case indicating their purpose:
*   DDL Schemas: Prefix `create_` (e.g. `create_silver_table.sql`).
*   ETL Load Scripts: Prefix `data_into_` (e.g. `data_into_silver.sql`).
