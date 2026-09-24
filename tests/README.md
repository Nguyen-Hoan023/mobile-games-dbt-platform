# Data Quality & Automated Tests

This directory represents the testing strategy for the Mobile Games Analytics Platform. We rely on dbt's robust testing framework to ensure data integrity and quality across all layers of our pipeline.

## Test Strategy

Our project currently focuses on **Schema / Generic Tests** configured directly within our YAML files (e.g., `schema.yml`, `models.yml`).

We enforce the following core assertions:
- `unique`: Ensures primary keys (like `app_id`) have no duplicates.
- `not_null`: Ensures critical fields (like `app_id`) never contain missing values.
- `accepted_values`: Guarantees that categorical fields remain within expected domains.

*Note: The project currently does not utilize custom singular SQL tests. All business logic validations are handled via generic schema tests.*

## Proof of Ingestion

Before transformations begin, we verify that Fivetran successfully replicated the source data from SQL Server to Supabase PostgreSQL.

![Test Results from Supabase](../images/test-results.png)
*(Screenshot showing successful data availability in Supabase after Fivetran ingestion)*

## Running Tests

To execute the test suite and validate data quality across staging, intermediate, and marts layers, run:

```bash
# Chạy toàn bộ test
dbt test
```

All predefined tests (covering the 15 business questions) currently PASS, ensuring a reliable foundation for the BI dashboards.
