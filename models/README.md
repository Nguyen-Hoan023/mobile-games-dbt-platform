# dbt Model Architecture

This directory contains the data transformations for the Mobile Games Analytics Platform. The project follows a structured 3-layer architecture (Staging → Intermediate → Marts) to ensure data quality, modularity, and optimized performance for BI tools.

## Architecture Pipeline

```text
+-------------------------------------------------------------------------------+
|                              Supabase PostgreSQL                              |
|                              (mobile_games.games)                             |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
|                               dbt Core Pipeline                               |
|                                                                               |
|  [ Staging Layer ]     -->   [ Intermediate Layer ]  -->     [ Marts Layer ]  |
|  Cleaning & Casting          Enrichment & Prep               Business Logic   |
|  stg_games.sql               int_games_enriched.sql          11 Analytical    |
|                              int_game_genres.sql             Marts            |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
|                                  dbt Charts                                   |
|                          (Dashboards & Reporting)                             |
+-------------------------------------------------------------------------------+
```

## Layer Definitions

### 1. Staging (`models/staging/`)
The staging layer serves as the entry point for raw data into the dbt project.
- **Models:** `stg_games.sql`
- **Purpose:** Light transformations, renaming columns to snake_case, casting data types, handling nulls (e.g., `nullif`), and basic text cleanup (`trim`).
- **Materialization:** `view`

### 2. Intermediate (`models/intermediate/`)
The intermediate layer handles complex logic that prepares data for the final marts.
- **Models:** `int_games_enriched.sql`, `int_game_genres.sql`
- **Purpose:** Reusable logic that shouldn't be duplicated across multiple marts. For example, parsing JSON arrays, standardizing pricing tiers, or flattening genre tags.
- **Materialization:** `view` or `ephemeral`

### 3. Marts (`models/marts/`)
The marts layer contains the final, business-ready models designed specifically to answer stakeholder questions (Q1-Q15) and power the dbt Charts dashboards.
- **Materialization:** `table` (for optimized query performance in BI)

| Mart Model | Business Purpose | Questions Answered |
|---|---|---|
| `mart_pricing` | Monetization distribution and pricing tiers | Q1, Q5 |
| `mart_developer_performance` | Developer leaderboards and consistency | Q2, Q13 |
| `mart_genre_performance` | Genre benchmarks by rating and age rating | Q3, Q7 |
| `mart_release_2019_by_genre` | Specific analysis of 2019 peak releases | Q4 |
| `mart_game_performance` | Top games identification and ranking | Q6, Q11 |
| `mart_size_by_genre` | Average game sizes grouped by genre | Q8 |
| `mart_localization` | Supported languages and localization analysis | Q9 |
| `mart_content_analysis` | Keyword extraction from game descriptions | Q10 |
| `mart_yearly_release_trends` | Year-over-year catalog growth | Q12 |
| `mart_size_vs_rating` | Correlation between game size and user rating | Q14 |
| `mart_genre_tags` | Analysis of overlapping multi-genre tags | Q15 |

For more details on the specific business questions, refer to the [BUSINESS_REQUIREMENTS.md](../BUSINESS_REQUIREMENTS.md) at the project root.
