-- TODO: build mart.revenue_by_zone from mart.rides
-- columns: pickup_zone, rides (count), revenue (sum of fare_amount, rounded to 2)
-- biggest revenue first

DROP TABLE IF EXISTS mart.revenue_by_zone;

CREATE TABLE mart.revenue_by_zone AS
SELECT
    pickup_zone,
    COUNT(*)                     AS ride_count,
    ROUND(SUM(fare_amount), 2)   AS total_revenue
FROM mart.rides
GROUP BY pickup_zone
ORDER BY total_revenue DESC;