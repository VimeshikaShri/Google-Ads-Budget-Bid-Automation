# Google Ads Budget & Bid Automation

I built this to solve a problem I kept running into at work: teams tracking budget pace and bid performance by hand in spreadsheets, days after the number that mattered had already moved. This is a small toolkit that includes SQL, Python, and a dashboard template for doing that monitoring automatically instead.

It grew out of the BigQuery reporting work I do in my day job (I own SQL/BigQuery dashboards that give Sales and Product self-serve visibility into operational data), applied here to Google Ads spend and bid data specifically.

**Note on data:** the queries and dashboard run against a synthetic sample dataset (`sample_metrics.csv`), not live client data. This is a demonstration of the approach and the code, not a production deployment.

## What's in here

- **`comprehensive_marketing_analytics.sql`**: BigQuery queries for campaign performance, multi-touch attribution, and budget forecasting against a standard `campaign_metrics` / `daily_metrics` schema.
- **`automated_bidding_strategy.py`**: Adjusts bids based on ROAS targets and pauses underperforming campaigns. Supports a `--dry-run` flag so you can see what it *would* do before it does it.
- **`budget_monitor.py`**: Checks spend pace against allocated budget on an interval and posts alerts to Slack when a campaign is over- or under-pacing.

## How the pieces fit together

```
sql_queries/        →  BigQuery views the dashboard and scripts read from
scripts/             →  automated_bidding_strategy.py, budget_monitor.py, utils.py
dashboards/          →  Looker Studio template + sample data
config.example.yaml  →  copy to config.yaml and fill in your own credentials (never commit this file)
```

## Running it

Requires Python 3.9+, a Google Ads developer token, and a GCP project with BigQuery enabled.

```bash
cp config.example.yaml config.yaml   # then fill in your credentials
python scripts/automated_bidding_strategy.py --config config.yaml --dry-run
python scripts/budget_monitor.py --config config.yaml --interval 3600
```

Credentials go in `config.yaml`, which is git-ignored — use OAuth 2.0 refresh tokens rather than static API keys where possible.

## Why I built it this way

The bidding script defaults to `--dry-run` because the failure mode I most wanted to avoid is a script silently pausing a campaign it should not have. I would rather it tell me what it is planning first. The SQL is written against BigQuery's standard export schema rather than a custom one, so it's portable to a real Google Ads BigQuery export with minimal changes to table names.


## Project Structure

```
adtech-portfolio/
├── dashboards/
│   ├── looker_studio_template.json
│   ├── dashboard_setup_guide.md
│   └── sample_metrics.csv
├── sql_queries/
│   ├── campaign_performance.sql
│   ├── keyword_analysis.sql
│   ├── attribution_model.sql
│   ├── budget_forecasting.sql
│   ├── cohort_analysis.sql
│   └── custom_metrics.sql
├── scripts/
│   ├── automated_bidding_strategy.py
│   ├── budget_monitor.py
│   ├── daily_optimization.py
│   ├── utils.py
│   └── setup.py
├── configs/
│   ├── google_ads_config.yaml
│   └── bigquery_config.yaml
├── docs/
│   ├── INSTALLATION.md
│   ├── USAGE.md
│   ├── API_REFERENCE.md
│   └── TROUBLESHOOTING.md
├── tests/
│   └── test_bidding_strategy.py
├── .gitignore
├── requirements.txt
├── config.example.yaml
└── LICENSE
```

## Dashboards

### Budget Pacing Dashboard
Real-time monitoring of daily spend vs. budget allocation:
- Campaign-level pace tracking
- Automated over/under spend alerts
- Budget rebalancing recommendations
- Historical spend trends

### Performance Dashboard
Campaign and keyword performance metrics:
- ROAS by campaign and keyword
- Cost per conversion trends
- Click-through rate (CTR) analysis
- Impression share tracking

### Attribution Dashboard
Multi-touch attribution analysis:
- First-click, last-click, and linear attribution
- Customer journey visualization
- Top-performing touchpoints
- Channel performance comparison

## Python Scripts

### Automated Bidding Strategy
Runs daily to optimize bids based on ROAS targets:

```bash
python scripts/automated_bidding_strategy.py --config config.yaml --dry-run
```

Features:
- ROAS-based bid optimization
- Daily budget reallocation
- Campaign performance pausing
- CPA target enforcement

### Budget Monitor
Real-time budget tracking with Slack alerts:

```bash
python scripts/budget_monitor.py --config config.yaml --interval 3600
```

### Daily Optimization
Automated daily performance adjustments:

```bash
python scripts/daily_optimization.py --config config.yaml
```

## SQL Queries

### Campaign Performance Analysis
Find top/bottom performing campaigns:
```sql
-- See sql_queries/campaign_performance.sql
SELECT campaign_name, impressions, clicks, cost, conversions, roas
FROM campaign_metrics
ORDER BY roas DESC
```

### Attribution Modeling
Multi-touch attribution analysis:
```sql
-- See sql_queries/attribution_model.sql
WITH attribution AS (
  SELECT user_id, touchpoint, revenue
  FROM events
)
SELECT touchpoint, SUM(revenue) as attributed_revenue
FROM attribution
GROUP BY touchpoint
```

### Budget Forecasting
Predict spend and ROI:
```sql
-- See sql_queries/budget_forecasting.sql
SELECT 
  DATE_TRUNC(event_date, MONTH) as month,
  SUM(cost) as projected_spend,
  SUM(revenue) / SUM(cost) as projected_roas
FROM daily_metrics
GROUP BY month
```

## Security

- Store credentials in `config.yaml` (never commit to git)
- Use OAuth 2.0 refresh tokens for authentication
- Rotate API keys regularly
- Use `.gitignore` to exclude sensitive files
- Implement rate limiting for API calls

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Add tests for new features
4. Submit a pull request

## Credits

Built for marketers and advertisers who need powerful analytics and automation without the enterprise price tag.

## Author

**<small>Vimeshika Shri : GitHub: [@VimeshikaShri](https://github.com/VimeshikaShri)</small>**

