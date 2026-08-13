-- schema/campaign_metrics_schema.sql
-- Creates the campaign_metrics table.
-- Load data afterwards with: data/campaign_metrics.csv (see README)

CREATE SCHEMA IF NOT EXISTS `ad-tech-portfolio.adtech_portfolio`
OPTIONS (description = "AdTech Marketing Analytics Portfolio — demo dataset");

CREATE TABLE IF NOT EXISTS `ad-tech-portfolio.adtech_portfolio.campaign_metrics` (
  campaign_id   STRING  NOT NULL,
  campaign_name STRING  NOT NULL,
  impressions   INT64,
  clicks        INT64,
  cost          NUMERIC,
  conversions   INT64,
  revenue       NUMERIC
)
OPTIONS (
  description = "Synthetic sample campaign performance data — one row per campaign. Not live client data."
);
