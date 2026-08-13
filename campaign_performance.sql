-- sql_queries/campaign_performance.sql
-- Campaign-level performance with ROAS computed on the fly.
-- Source table: adtech_portfolio.campaign_metrics

SELECT
  campaign_id,
  campaign_name,
  impressions,
  clicks,
  cost,
  conversions,
  revenue,
  SAFE_DIVIDE(revenue, cost) AS roas
FROM `ad-tech-portfolio.adtech_portfolio.campaign_metrics`;
