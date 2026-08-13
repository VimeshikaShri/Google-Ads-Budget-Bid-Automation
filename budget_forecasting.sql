-- sql_queries/budget_forecasting.sql
-- Monthly projected spend and ROAS.
-- Source table: adtech_portfolio.daily_metrics
-- Note: GROUP BY 1 groups by the first SELECT column (the month).

SELECT
  DATE_TRUNC(event_date, MONTH) AS month,
  SUM(cost) AS projected_spend,
  SAFE_DIVIDE(SUM(revenue), SUM(cost)) AS projected_roas
FROM `ad-tech-portfolio.adtech_portfolio.daily_metrics`
GROUP BY 1;
