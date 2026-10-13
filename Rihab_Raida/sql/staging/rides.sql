-- TODO: rebuild staging.rides from raw.rides
-- keep all 7 columns, but only the GOOD rides:
--   - no duplicates
--   - fare_amount > 0
--   - driver_id exists in raw.drivers

DROP TABLE IF EXISTS staging.rides;

CREATE TABLE staging.rides AS
SELECT DISTINCT ON (r.ride_id) r.*
FROM raw.rides r
WHERE r.fare_amount > 0
  AND EXISTS (
      SELECT 1
      FROM raw.drivers d
      WHERE d.driver_id = r.driver_id
  )
ORDER BY r.ride_id;