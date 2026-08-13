# Google Ads Budget & Bid Automation: AdTech Analytics Portfolio

A **BigQuery-based marketing analytics portfolio** that demonstrates how paid-media data can be modeled, queried, and turned into decision-ready metrics: **Campaign performance (ROAS)**, **Multi-touch attribution**, and **Budget forecasting**.



## Overview

Modern ad-tech teams live and die by three questions:

1. **Which campaigns make money?** → *Campaign Performance (ROAS)*
2. **Which channels deserve credit for revenue?** → *Attribution Modeling*
3. **How should we allocate next month's budget?** → *Budget Forecasting*

This project answers all three using **Google BigQuery** as the data warehouse and **standard SQL** as the analysis layer. It is designed to be fully reproducible: anyone can clone the repo, run the schema files, load the sample CSVs, and get the same results, as no billing account is required.



## Skills & Tools Demonstrated

| Area | What's shown |
|------|--------------|
| **Data warehousing** | BigQuery dataset & table design (DDL) |
| **SQL analytics** | CTEs, aggregation, date truncation, safe division |
| **Marketing metrics** | ROAS, attributed revenue, projected spend/ROI |
| **Data loading** | `bq load` CSV ingestion (works in BigQuery sandbox) |
| **Documentation** | Reproducible setup, data dictionary, sample outputs |

**Stack:** Google BigQuery · Standard SQL · Cloud Shell / `bq` CLI · CSV


## Data Dictionary

### `campaign_metrics`: One row per campaign
| Column | Type | Description |
|--------|------|-------------|
| campaign_id | STRING | Unique campaign identifier |
| campaign_name | STRING | Human-readable campaign name |
| impressions | INT64 | Times the ad was shown |
| clicks | INT64 | Times the ad was clicked |
| cost | NUMERIC | Total spend on the campaign |
| conversions | INT64 | Completed desired actions |
| revenue | NUMERIC | Revenue attributed to the campaign |

### `events`: One row per user touchpoint
| Column | Type | Description |
|--------|------|-------------|
| user_id | STRING | Anonymous user identifier |
| touchpoint | STRING | Marketing channel (email, social_ad, search_ad) |
| revenue | FLOAT64 | Revenue from that user |

### `daily_metrics`: One row per day
| Column | Type | Description |
|--------|------|-------------|
| event_date | DATE | Calendar date |
| cost | FLOAT64 | Spend on that day |
| revenue | FLOAT64 | Revenue on that day |



## Analyses & Sample Outputs

### 1. Campaign Performance (ROAS): `sql_queries/campaign_performance.sql`

Computes **Return on Ad Spend** per campaign using `SAFE_DIVIDE` (avoids divide-by-zero).

```sql
SELECT campaign_id, campaign_name, cost, revenue,
       SAFE_DIVIDE(revenue, cost) AS roas
FROM `ad-tech-portfolio.adtech_portfolio.campaign_metrics`;
```

| campaign | cost | revenue | **ROAS** |
|----------|-----:|--------:|---------:|
| Brand - Search | 8,512.60 | 38,610.00 | **4.54** |
| Prospecting - Display | 6,365.65 | 9,450.00 | **1.48** |
| Retargeting - Shopping | 5,416.40 | 45,960.00 | **8.49** |
| Video - YouTube | 11,810.15 | 15,920.00 | **1.35** |
| Competitor - Search | 7,940.20 | 16,830.00 | **2.12** |

*Insight:* **Retargeting - Shopping (8.49)** and **Brand - Search (4.54)** are the strongest performers; **Video - YouTube (1.35)** is closest to break-even.

### 2. Attribution Model: `sql_queries/attribution_model.sql`

Sums revenue by touchpoint using a CTE.

```sql
WITH attribution AS (
  SELECT user_id, touchpoint, revenue
  FROM `ad-tech-portfolio.adtech_portfolio.events`
)
SELECT touchpoint, SUM(revenue) AS attributed_revenue
FROM attribution
GROUP BY touchpoint;
```

| touchpoint | attributed_revenue |
|------------|-------------------:|
| social_ad | 650.00 |
| email | 245.00 |
| search_ad | 200.00 |

*Insight:* **social_ad** drives the most attributed revenue in this sample.

### 3. Budget Forecasting: `sql_queries/budget_forecasting.sql`

Aggregates daily data to monthly spend and projected ROAS.

```sql
SELECT DATE_TRUNC(event_date, MONTH) AS month,
       SUM(cost) AS projected_spend,
       SAFE_DIVIDE(SUM(revenue), SUM(cost)) AS projected_roas
FROM `ad-tech-portfolio.adtech_portfolio.daily_metrics`
GROUP BY 1;
```

| month | projected_spend | projected_roas |
|-------|----------------:|---------------:|
| 2025-01 | 925.00 | 3.24 |
| 2025-02 | 990.00 | 3.44 |

*Insight:* Spend increased month-over-month while ROAS also improved, a healthy scaling signal.



## Screenshots (proof of work)

### Data loading via Cloud Shell (`bq load`)
![Cloud Shell data load](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/1.%20Cloud%20Shell%20Terminal.png)

**Loading `events` and `daily_metrics` (full terminal session):**
![](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/Terminal%20part%201.png)

**Catching the duplicate-row bug and fixing it with `--replace`, then verifying `COUNT(*) = 10`:**
![](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/Terminal%20part%202.png)

### 1. Campaign Performance (ROAS)
![ROAS query results](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/2.%20ROAS.png)

### 2. Attribution Model
**Creating the `events` table:**
![Events table create](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/3.%20Created%20table%20for%20attribution%20modelling.png)

**`events` table schema:**
![Events schema](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/4.%20Events%20table%20created%20(Attribution%20modelling).png)

**Attributed revenue results:**
![Attribution results](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/5.%20Attributed%20revenue.png)

### 3. Budget Forecasting
**Creating the `daily_metrics` table:**
![Daily metrics create](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/6.%20Created%20table%20for%20Budget%20Forecasting%20(Predict%20spend%20and%20ROI).png)

**`daily_metrics` table schema:**
![Daily metrics schema](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/7.%20Events%20table%20created%20for%20Budget%20Forecasting.png)

**Budget forecasting results:**
![Budget forecasting results](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/8.%20Budget%20forecasting.png)
![](https://github.com/VimeshikaShri/Google-Ads-Budget-Bid-Automation/blob/main/9.png)



## Setup & Reproduction (no billing account needed)

BigQuery **sandbox mode** allows DDL (`CREATE TABLE`) and `bq load`, but blocks `INSERT` (DML). This project is built around that constraint.

1. **Replace the project ID.** In every `.sql` file, swap `ad-tech-portfolio.` for your own GCP project ID.

2. **Create the tables.** Open each file in `schema/` in the
   [BigQuery console](https://console.cloud.google.com/bigquery) and click **Run**.

3. **Load the sample data.** From Cloud Shell (or any terminal with `bq`):

```bash
bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  ad-tech-portfolio:adtech_portfolio.campaign_metrics data/campaign_metrics.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  ad-tech-portfolio:adtech_portfolio.events data/events.csv

bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
  ad-tech-portfolio:adtech_portfolio.daily_metrics data/daily_metrics.csv
```

4. **Run the analyses.** Open each file in `sql_queries/` and click **Run**.

5. **Validate your load.** Confirm row counts match the CSVs:

```sql
SELECT COUNT(*) FROM `ad-tech-portfolio.adtech_portfolio.campaign_metrics`;  -- expect 5
SELECT COUNT(*) FROM `ad-tech-portfolio.adtech_portfolio.events`;           -- expect 8
SELECT COUNT(*) FROM `ad-tech-portfolio.adtech_portfolio.daily_metrics`;    -- expect 10
```

> **Troubleshooting duplicate rows:** `bq load` *appends* by default. If a count is
> double what you expect, the same CSV was loaded twice. Reload with `--replace`
> (truncates first) to get back to a clean single load:
>
> ```bash
> bq load --replace --source_format=CSV --autodetect --skip_leading_rows=1 \
>   ad-tech-portfolio:adtech_portfolio.daily_metrics data/daily_metrics.csv
> ```



## Key Formulas

| Metric | Formula |
|--------|---------|
| **ROAS** | `revenue / cost` (via `SAFE_DIVIDE`) |
| **Attributed revenue** | `SUM(revenue)` grouped by touchpoint |
| **Projected ROAS** | `SUM(revenue) / SUM(cost)` grouped by month |

`SAFE_DIVIDE` is used everywhere a division occurs so a zero-cost row returns
`NULL` instead of crashing the query.



## Possible Extensions

- Last-click / linear / time-decay attribution variants
- ROAS thresholds with automated bid recommendations
- Looker Studio dashboard connected to these tables


> **Data disclaimer:** All data in this repository is **synthetic sample data** generated for demonstration purposes. It is **not** live client or company data.


## Author

**<small>Vimeshika Shri : GitHub: [@VimeshikaShri](https://github.com/VimeshikaShri)</small>**
