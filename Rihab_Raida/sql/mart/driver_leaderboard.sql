-- TODO: build mart.driver_leaderboard from mart.rides + staging.vehicles
-- columns: driver_name, vehicle_type, rating, rides (count), revenue (sum of fare_amount, rounded to 2)
-- biggest revenue first

DROP TABLE IF EXISTS mart.driver_leaderboard;

CREATE TABLE mart.driver_leaderboard AS
WITH per_driver AS (
    SELECT
        driver_id,
        driver_name,
        rating,
        COUNT(*)                   AS ride_count,
        ROUND(SUM(fare_amount), 2) AS total_revenue
    FROM mart.rides
    GROUP BY driver_id, driver_name, rating
)
SELECT
    p.driver_name,
    v.vehicle_type,
    p.rating,
    p.ride_count,
    p.total_revenue
FROM per_driver p
LEFT JOIN staging.vehicles v ON v.driver_id = p.driver_id
ORDER BY p.total_revenue DESC;