# models/

This directory contains all dbt transformation models for the Mobile Games Analytics Platform. Models are organized into three layers following a strict separation of concerns.

---

## Layer Architecture

```
models/
└── mobile_games/
    ├── staging/
    │   └── stg_games.sql           -- raw → clean source data
    ├── intermediate/
    │   ├── int_games_enriched.sql  -- core enrichment, shared by all marts
    │   └── int_game_genres.sql     -- genre tag parsing
    └── marts/
        ├── mart_pricing.sql
        ├── mart_genre_performance.sql
        ├── mart_genre_tags.sql
        ├── mart_game_performance.sql
        ├── mart_developer_performance.sql
        ├── mart_release_2019_by_genre.sql
        ├── mart_yearly_release_trends.sql
        ├── mart_size_by_genre.sql
        ├── mart_size_vs_rating.sql
        ├── mart_localization.sql
        └── mart_content_analysis.sql
```

Materialization is configured in [`dbt_project.yml`](../dbt_project.yml):
- `staging/` → `view`
- `intermediate/` → `view`
- `marts/` → `table`

---

## Layer Descriptions

### Staging (`staging/`)

**Role:** Entry point for raw source data. Applies only lightweight, non-destructive transformations.

**What it does:**
- Casts columns to correct types (`bigint`, `numeric`, `date`, `integer`)
- Cleans strings with `trim()` and `nullif()` to remove whitespace-only values
- Derives `size_mb` from `size_in_bytes` for human-readable size
- Filters out Fivetran soft-deleted rows via `WHERE coalesce(_fivetran_deleted, false) = false`

**Models:**

| Model | Source | Grain |
| :--- | :--- | :--- |
| `stg_games` | `mobile_games.games` (Supabase) | One row per App Store game (`app_id`) |

---

### Intermediate (`intermediate/`)

**Role:** Shared business logic and derived fields reused across multiple marts. Prevents duplication and ensures consistency.

**What it does:**
- `int_games_enriched`: Adds enriched fields used by most marts — `language_count` (parsed from the `languages` string), `release_year`, and any other enriched attributes. This is the primary base model for all 11 marts.
- `int_game_genres`: Parses the `genres` field (a comma-separated tag string) into individual genre rows for `mart_genre_tags`.

**Design rationale:** Without this intermediate layer, logic like `language_count` parsing or `release_year` extraction would need to be repeated in every mart independently — creating maintenance risk and inconsistency.

---

### Marts (`marts/`)

**Role:** Business-facing analytical tables. Each mart is purpose-built to answer one or more stakeholder questions. All marts are materialized as `table` for optimal dashboard query performance.

| Mart | Business Questions | Key Output Columns |
| :--- | :--- | :--- |
| `mart_pricing` | Q1 (Free vs Paid), Q5 (Price bands) | `price_band`, `pricing_model`, `games`, `pct_of_total`, `avg_rating` |
| `mart_genre_performance` | Q3 (Genre benchmarks), Q7 (Age rating × genre) | `primary_genre`, `games`, `avg_rating`, `avg_review_count`, `age_4_plus` … `age_17_plus` |
| `mart_game_performance` | Q6 (High-rated titles), Q11 (Top 3 per genre) | `name`, `developer`, `average_user_rating`, `user_rating_count`, `q6_rank`, `q11_rank` |
| `mart_developer_performance` | Q2 (Top developers), Q13 (Consistency) | `developer`, `games`, `avg_rating`, `total_reviews`, `q2_rank`, `q13_rating_stdev` |
| `mart_release_2019_by_genre` | Q4 (2019 releases) | `primary_genre`, `games_released`, `avg_rating` |
| `mart_yearly_release_trends` | Q12 (YoY release growth) | `release_year`, `games_released`, `yoy_growth_pct`, `prev_year_games` |
| `mart_size_by_genre` | Q8 (Game size by genre) | `primary_genre`, `games`, `avg_size_mb`, `max_size_mb` |
| `mart_size_vs_rating` | Q14 (Size vs rating) | `size_band`, `games`, `avg_rating`, `avg_review_count` |
| `mart_localization` | Q9 (Language support) | `primary_genre`, `games`, `avg_language_count`, `max_language_count` |
| `mart_content_analysis` | Q10 (Description keywords) | `primary_genre`, `mentions_puzzle`, `mentions_multiplayer`, `mentions_either` |
| `mart_genre_tags` | Q15 (Genre tag frequency) | `genre_tag`, `games`, `avg_rating`, `genre_rank` |

For the full business definitions of Q1–Q15, see [`BUSINESS_REQUIREMENTS.md`](../BUSINESS_REQUIREMENTS.md).

---

## Running Models

```bash
# Run all models (staging + intermediate + marts)
dbt run

# Run only the marts layer
dbt run --select marts

# Run a specific mart
dbt run --select mart_pricing

# Run with downstream dependents
dbt run --select int_games_enriched+
```
