-- sql_queries/attribution_model.sql
-- Revenue attributed to each marketing touchpoint.
-- Source table: adtech_portfolio.events

WITH attribution AS (
  SELECT user_id, touchpoint, revenue
  FROM `ad-tech-portfolio.adtech_portfolio.events`
)
SELECT
  touchpoint,
  SUM(revenue) AS attributed_revenue
FROM attribution
GROUP BY touchpoint;
