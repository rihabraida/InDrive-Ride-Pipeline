# ANSWERS — InDrive Ride Pipeline (Light version)

Name: 

Short answers (1-3 sentences). Write them as you go.

## Q1 — Which sources are **batch** and which is **streaming**? Why does the data team handle them differently? Which one is the **fact** and which are the **dimensions**?

Your answer:

The 3 CSV files (drivers, vehicles, zones) are **batch**: small, rarely changed, reloaded in full on a schedule. The ride events from the API are **streaming**: a continuous flow of new rows, ingested every minute. They are handled differently because they differ in volume, speed and how often they change. `rides` is the **fact** table (events that keep growing); `drivers`, `vehicles` and `zones` are the **dimensions** (descriptive data: who, what, where).

## Q2 — Is this pipeline **ETL** or **ELT**? Justify in 1-2 sentences, using the 3 layers.

Your answer:

It is **ELT**. Data is loaded as-is into `raw` first, then transformed inside Postgres with SQL, into `staging` (cleaning) and then `mart` (business tables). In ETL, the cleaning would happen before the data reaches the database.

## Q3 — Write the grain of `mart.rides` in one sentence: "one row = ..."

Your answer:

One row = one ride (unique `ride_id`), with its driver, rating, pickup zone, dropoff zone, distance and fare.

## Q4 — `staging.zones` is joined twice in `mart.rides`. What do we call this pattern? Why not make two zone tables?

Your answer:

This is a **role-playing dimension**: the same dimension plays two roles (pickup and dropoff) in the same fact. We don't make two zone tables because it is the same data: two copies would be duplicated and could drift apart. One table with two aliases (`pz`, `dz`) keeps a single source of truth.

## Q5 — How many rides are in `raw.rides`, in `staging.rides`? Where did the others go? Why is filtering in staging better than letting the `JOIN` in the mart drop them silently?

Your numbers: `raw.rides` = 9170 ; `staging.rides` = 8454

Your answer:

716 rides (about 7.8%) were removed in staging: rides with an unknown driver (`driver_id = 999`, about 5% of the stream), duplicate rides (same `ride_id` ingested more than once), and rides with `fare_amount <= 0`. Filtering in staging is better because the rule is explicit and testable: we can count exactly what was rejected and why. A `JOIN` in the mart drops rows silently, depending on the join type, so nobody notices when data disappears.

## Q6 — You re-run `3_staging` three times. Why is there no duplicate? What would happen if the SQL used `INSERT INTO` instead of `DROP` + `CREATE TABLE AS`?

Your answer:

`DROP TABLE` + `CREATE TABLE AS` rebuilds the table completely from `raw` on every run, so the result is always the same (**idempotent**). With `INSERT INTO`, each run would append the same rows again, so three runs would triple the data.

## Q7 — Is `fare_amount` additive, semi-additive or non-additive? And `rating`? What would be wrong with `SUM(rating)`?

Your answer:

`fare_amount` is **additive**: it can be summed across any dimension (zone, driver, day). `rating` is **non-additive**: it is a quality score, so it can be averaged but not summed. `SUM(rating)` is meaningless because it grows with the number of rides, not with quality (three rides rated 5 give 15, outside the 1-5 scale).

## Q8 — The back office changes a driver's rating in `drivers.csv` and `2_batch` reloads it. What happens to the **old** rides of this driver in `mart.rides`? Is it correct for InDrive? Which technique would keep the rating the driver had *at the time of the ride*?

Your answer:

The old rides show the **new** rating, because `mart.rides` is rebuilt from `staging.drivers` on every run, which rewrites history. This is **not correct** for InDrive: those rides happened when the driver had the old rating, so any analysis of rating versus ride outcome is distorted. **SCD Type 2** (Slowly Changing Dimension) fixes it: keep one row per version of the driver with `valid_from`, `valid_to` and `is_current`, and join each ride to the version valid at its `requested_at`.

## Bonus (optional)

- New mart `mart.revenue_by_vehicle_type`: paste your SQL here.

```sql
