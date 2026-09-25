# charts/

This directory contains the dbt Charts dashboard definitions for the Mobile Games Analytics Platform. Charts sit directly on top of the `marts/` layer and translate analytical mart output into visual, interactive dashboards.

---

## Directory Structure

```
charts/
├── mobile_games_overview.yml   -- Executive Overview dashboard
├── mobile_games_research.yml   -- Research Board (4-tab, Q1–Q15)
└── README.md
```

Each `.yml` file defines:
- **`queries`**: Named SQL blocks that pull from dbt mart tables (`dbt_dev.*`)
- **`charts`**: Visual specifications (type, axes, formatting) referencing query results
- **`rows` / `tabs`**: Layout config controlling how charts are arranged on the dashboard

---

## Dashboard 1: Executive Overview (`mobile_games_overview.yml`)

**Audience:** Leadership, project reviewers wanting a quick catalog snapshot.

**Queries used:** `catalog_kpis`, `genre_performance`, `pricing_mix`, `release_trends`, `top_developers`

**Charts:**

| Chart ID | Type | Metric |
| :--- | :--- | :--- |
| `game_count_kpi` | KPI | Total games in catalog |
| `average_rating_kpi` | KPI | Catalog average user rating |
| `total_reviews_kpi` | KPI | Sum of all user reviews |
| `genre_rating` | Bar | Avg rating per genre (desc) |
| `genre_reviews` | Bar | Avg review count per genre (desc) |
| `release_trend` | Line | Games released per year |
| `top_developers` | Horizontal bar | Top 10 developers by game count |
| `pricing_mix` | Bar | Free vs Paid catalog share (%) |

---

## Dashboard 2: Research Board (`mobile_games_research.yml`)

**Audience:** Data analysts, technical reviewers exploring the full Q1–Q15 question set.

This dashboard is organized into **4 tabs**. Each tab maps to a thematic group of business questions.

---

### Tab 1: Executive

![Tab 1](../images/Executive.png)

Provides a high-level overview of the Mobile Games catalog, focusing on monetization, genre performance, and release trends.

**Charts:**

| Chart ID | Type | Answers |
| :--- | :--- | :--- |
| `game_count_kpi`, `average_rating_kpi`, `total_reviews_kpi` | KPI row | Catalog health |
| `q1_free_paid` | Bar (%) | Q1 — Free vs Paid split |
| `q5_price_bands` | Bar (%) | Q5 — Price band distribution |
| `q3_rating` | Bar | Q3 — Avg rating by genre |
| `q3_reviews` | Bar | Q3 — Avg review count by genre |
| `q12_release_trend` | Line | Q12 — Games released per year |
| `q12_rating_trend` | Line | Q12 — Avg rating per release year |

---

### Tab 2: Market and Portfolio

![Tab 2](../images/Market%20and%20Portfolio.jpeg)

Explores market leaders and structural characteristics of the portfolio, including developer presence, release activity, size, localization, and genre categorization.

**Charts:**

| Chart ID | Type | Answers |
| :--- | :--- | :--- |
| `q2_top_developers` | Horizontal bar | Q2 — Top 10 developers by game count |
| `q4_release_2019` | Bar | Q4 — 2019 releases by genre |
| `q8_size` | Bar | Q8 — Avg game size (MB) by genre |
| `q9_localization` | Bar | Q9 — Avg languages supported by genre |
| `q15_genre_tags` | Horizontal bar | Q15 — Top 15 genre tags by frequency |
| `q13_consistency` | Table | Q13 — Developer rating consistency (stdev) |

---

### Tab 3: Quality and Trends

![Tab 3](../images/Quality%20and%20Trends.jpeg)

Analyzes game quality, performance, release trends, and the relationship between technical characteristics and user ratings.

**Charts:**

| Chart ID | Type | Answers |
| :--- | :--- | :--- |
| `q7_age_genre` | Heatmap | Q7 — Age rating × genre cross-tab |
| `q14_size_rating` | Bar | Q14 — Avg rating by size band |
| `q6_high_rated` | Table | Q6 — Top 20 high-rated, high-reviewed games |
| `q11_top_games` | Table | Q11 — Top 3 games per genre |
| `q12_yoy` | Bar | Q12 — YoY release growth rate |

---

### Tab 4: Content and Discovery

![Tab 4](../images/Content%20and%20Discovery.png)

Analyzes gameplay content keywords found in App Store descriptions, highlighting puzzle and multiplayer prevalence across genres.

**Charts:**

| Chart ID | Type | Answers |
| :--- | :--- | :--- |
| `q10_keyword_heatmap` | Heatmap | Q10 — Puzzle vs Multiplayer keyword by genre |
| `q10_content_table` | Table | Q10 — Detailed keyword mention counts |

---

## Chart-to-Question Reference

For the full business definitions of Q1–Q15 (purpose, mart source, key metrics), see [`BUSINESS_REQUIREMENTS.md`](../BUSINESS_REQUIREMENTS.md).

---

## Running dbt Charts

```bash
# Preview dashboards locally (check your dbt Charts setup for exact command)
dbt-charts serve
```
