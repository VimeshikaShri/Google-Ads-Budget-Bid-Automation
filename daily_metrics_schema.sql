-- schema/daily_metrics_schema.sql
-- Creates the daily_metrics table used by sql_queries/budget_forecasting.sql
-- Load data afterwards with: data/daily_metrics.csv (see README)

CREATE TABLE IF NOT EXISTS `ad-tech-portfolio.adtech_portfolio.daily_metrics` (
  event_date DATE,
  cost       FLOAT64,
  revenue    FLOAT64
)
OPTIONS (
  description = "Synthetic daily cost and revenue for budget forecasting"
);
