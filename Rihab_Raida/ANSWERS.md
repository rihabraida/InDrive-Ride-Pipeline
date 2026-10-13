# ANSWERS — InDrive Ride Pipeline (Light version)

Name: 

Short answers (1-3 sentences). Write them as you go.

## Q1 — Which sources are **batch** and which is **streaming**? Why does the data team handle them differently? Which one is the **fact** and which are the **dimensions**?

Your answer:


## Q2 — Is this pipeline **ETL** or **ELT**? Justify in 1-2 sentences, using the 3 layers.

Your answer:


## Q3 — Write the grain of `mart.rides` in one sentence: "one row = ..."

Your answer:


## Q4 — `staging.zones` is joined twice in `mart.rides`. What do we call this pattern? Why not make two zone tables?

Your answer:


## Q5 — How many rides are in `raw.rides`, in `staging.rides`? Where did the others go? Why is filtering in staging better than letting the `JOIN` in the mart drop them silently?

Your numbers: `raw.rides` = ____ ; `staging.rides` = ____

Your answer:


## Q6 — You re-run `3_staging` three times. Why is there no duplicate? What would happen if the SQL used `INSERT INTO` instead of `DROP` + `CREATE TABLE AS`?

Your answer:


## Q7 — Is `fare_amount` additive, semi-additive or non-additive? And `rating`? What would be wrong with `SUM(rating)`?

Your answer:


## Q8 — The back office changes a driver's rating in `drivers.csv` and `2_batch` reloads it. What happens to the **old** rides of this driver in `mart.rides`? Is it correct for InDrive? Which technique would keep the rating the driver had *at the time of the ride*?

Your answer:


## Bonus (optional)

- New mart `mart.revenue_by_vehicle_type`: paste your SQL here.
- Break it (`raw.zonez`): what did you see in the Airflow logs?
