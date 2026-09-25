# Business Requirements

## 1. Document Control

| Item | Definition |
|---|---|
| Business domain | Mobile game market analytics |
| Business owner | Analytics Team |
| Primary users | Data Analysts, Business Stakeholders, Product Managers |
| Source | SQL Server `mobile_games.games` |
| Grain | One row per App Store game (`app_id`) |
| Delivery style | Dashboards, rankings, benchmarks, trends, and ad-hoc analysis |

## 2. Business Context

This project provides market research and analytics based on a snapshot of a mobile game catalog. The platform is designed to help stakeholders understand catalog composition, popularity, ratings, monetization, game size, genres, developer portfolios, and release trends.

**Important Data Constraints:**
The dataset contains catalog metadata only. It does not contain transactional data, revenue, installs, retention, or player-level behavior. Therefore:
- `user_rating_count` is used as the proxy for popularity or market attention.
- `price_usd` is used as the proxy for monetization model and price positioning.
- Ratings describe user sentiment, not necessarily commercial success.
- Results are presented as catalog benchmarks, not revenue claims.

## 3. Goals

1. Provide trusted rankings and benchmarks for genres and developers.
2. Compare free and paid games using review volume and ratings.
3. Identify release, rating, size, language, age-rating, and price patterns.
4. Support repeatable stakeholder questions through robust dbt models and dbt Charts.
5. Ensure data quality and traceability from source to dashboard.

## 4. Scope

### In scope
- Fivetran replication from SQL Server to Supabase PostgreSQL.
- dbt Core staging, intermediate transformations, and analytical marts.
- Data quality testing using dbt schema tests (unique, not_null, accepted_values).
- BI layer implementation using dbt Charts.
- Answering the 15 predefined stakeholder questions (Q1–Q15).

### Out of scope
- Revenue, sales, installs, retention, conversion, or profitability analysis.
- Causal claims (e.g., "larger games cause higher ratings").
- Joining to other tables (the source currently operates as a single denormalized table).
- Custom singular SQL tests (relying on generic schema tests).

## 5. Source Data Contract

Source table: `mobile_games.games` (after Fivetran replication).

| Column | Source Type | Nullable | Business Meaning |
|---|---|---|---|
| `app_url` | string | Yes | App Store URL |
| `app_id` | bigint | No | App Store identifier (Primary Key) |
| `name` | string | Yes | Game title |
| `subtitle` | string | Yes | App Store subtitle |
| `icon_url` | string | Yes | Game icon URL |
| `average_user_rating` | numeric | Yes | Average user rating (Sentiment) |
| `user_rating_count` | integer | Yes | Number of user ratings/reviews (Popularity proxy) |
| `price_usd` | numeric | Yes | Listed price in USD (Monetization proxy) |
| `description` | string | Yes | App Store description (Keyword analysis) |
| `developer` | string | Yes | Developer/publisher name |
| `age_rating` | string | Yes | Store age-rating label |
| `languages` | string | Yes | Supported language list |
| `size_in_bytes` | bigint | Yes | Download size |
| `primary_genre` | string | Yes | Main App Store genre |
| `genres` | string | Yes | All genre tags |
| `release_date` | date | Yes | App Store release date |

## 6. Stakeholder Questions (Q1–Q15)

The following 15 business questions drive the design of the analytical marts and dashboards.

| Q | Business Question | Business Purpose | Target Mart | Key Metrics | Dashboard Section |
|---|---|---|---|---|---|
| **Q1** | Compare free vs paid games | Understand monetization distribution | `mart_pricing` | Count, %, avg rating, avg reviews | Overview + Tab 1: Executive |
| **Q2** | Top Developers / Publishers | Identify market leaders by portfolio size | `mart_developer_performance` | Game count per developer, top 10 | Overview + Tab 2: Market and Portfolio |
| **Q3** | Genre Performance (ratings & reviews) | Benchmark genres by user engagement | `mart_genre_performance` | Avg rating, avg review count per genre | Overview + Tab 1: Executive |
| **Q4** | 2019 Release Analysis by Genre | Understand peak-year release patterns | `mart_release_2019_by_genre` | Game count by genre in 2019 | Research Tab 4: Content and Discovery |
| **Q5** | Price Distribution of Paid Games | Understand pricing tiers | `mart_pricing` | Count per price bucket ($0.99, $1.99, etc.) | Research Tab 1: Executive |
| **Q6** | High-rated & Highly-reviewed Games | Find standout titles | `mart_game_performance` | Games with rating >= 4.5 AND high reviews | Tab 3: Quality and Trends |
| **Q7** | Age Rating × Genre | Audience segmentation by genre | `mart_genre_performance` | Cross-tab of age_rating × primary_genre | Tab 3: Quality and Trends |
| **Q8** | Game Size by Genre | Understand download size patterns | `mart_size_by_genre` | Avg size_mb per genre | Tab 2: Market and Portfolio |
| **Q9** | Localization (Language Support) | Identify globally-oriented titles | `mart_localization` | Avg languages per game, top combos | Tab 2: Market and Portfolio |
| **Q10** | Description Keywords | Identify common marketing language | `mart_content_analysis` | Top keywords from description field | Research Tab 4: Content and Discovery |
| **Q11** | Top Games per Genre | Genre-level leaderboards | `mart_game_performance` | Top 3 games ranked by reviews per genre | Tab 3: Quality and Trends |
| **Q12** | Release Trends / YoY | Understand catalog growth over time | `mart_yearly_release_trends` | Game count per year, YoY growth % | Overview + Tab 1: Executive + Tab 3: Quality and Trends |
| **Q13** | Developer Consistency | Identify developers with consistent quality | `mart_developer_performance` | Std deviation of rating per developer | Research Tab 2: Market and Portfolio |
| **Q14** | Game Size vs Rating | Explore size-rating relationship | `mart_size_vs_rating` | Scatter: size_mb vs avg_rating | Research Tab 3: Quality and Trends |
| **Q15** | Genre Tags (Multi-genre games) | Understand genre overlap | `mart_genre_tags` | Frequency of genre tag combinations | Research Tab 2: Market and Portfolio |
