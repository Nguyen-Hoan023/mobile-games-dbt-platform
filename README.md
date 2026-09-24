# Mobile Games Analytics Platform 🎮

![Project Architecture](images/architecture.*)

An end-to-end modern data stack project analyzing a mobile game catalog to extract market insights, answer business questions, and power interactive dashboards.

## Overview & Pipeline

This platform processes mobile app store metadata to deliver insights on monetization, developer portfolios, genres, and release trends. The data flows through a 5-step pipeline:

1. **Source**: Microsoft SQL Server containing raw `mobile_games.games` dataset.
2. **Replication**: **Fivetran** securely replicates source data into the data warehouse.
   *(See [Fivetran Connection Setup](images/fivetran-sql.*))*
3. **Warehouse**: **Supabase (PostgreSQL)** serves as the analytical backend.
4. **Transformation**: **dbt Core** cleans, enriches, and models the data through a 3-layer architecture (Staging → Intermediate → Marts).
5. **Analytics & BI**: **dbt Charts** visualizes the 11 analytical marts to answer 15 specific stakeholder questions.

## Repository Structure

| Directory | Purpose |
| :--- | :--- |
| [`BUSINESS_REQUIREMENTS.md`](BUSINESS_REQUIREMENTS.md) | Business context, Source Data Contract, and the 15 Stakeholder Questions (Q1-Q15). |
| [`models/`](models/README.md) | The 3-layer dbt architecture (Staging, Intermediate, Marts). |
| [`charts/`](charts/README.md) | dbt Charts dashboard specifications and visual research board mapping. |
| [`tests/`](tests/README.md) | Data quality assurance and schema tests strategy. |
| [`images/`](images/) | Architectural diagrams and dashboard screenshots. |

## Data Governance & Documentation

We use dbt Docs to maintain a comprehensive, navigable data catalog and lineage graph for the entire pipeline.

![dbt Docs Preview](images/dbt-docs.*)

## Quick Start

### Requirements
- Python 3.8+
- dbt-postgres
- Access to the target Supabase database

### Commands

```bash
# 1. Cài đặt các thư viện phụ thuộc (nếu cần)
dbt deps

# 2. Chạy toàn bộ pipeline transformation (từ staging đến marts)
dbt run

# 3. Chạy kiểm thử chất lượng dữ liệu
dbt test

# 4. Khởi tạo và xem tài liệu dbt Docs
dbt docs generate
dbt docs serve
```
