-- schema/events_schema.sql
-- Creates the events table used by sql_queries/attribution_model.sql
-- Load data afterwards with: data/events.csv (see README)

CREATE TABLE IF NOT EXISTS `ad-tech-portfolio.adtech_portfolio.events` (
  user_id    STRING,
  touchpoint STRING,
  revenue    FLOAT64
)
OPTIONS (
  description = "Synthetic user touchpoint events for attribution modeling"
);
