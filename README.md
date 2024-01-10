# Climbs
A sample project using dbt on postgres for Climbing data.


# DB (with Postgres)
Spin up the Postgres database using the spin_up_postgres.sh script.

To load seed data into tables:
`dbt seed`


To create lineage diagram:
`dbt docs generate`
`dbt docs serve`


# Project ideas
- Deploy S3 bucket for Seeds, Glue crawler, Glue DB:
- `cd cdk/ && cdk deploy dev-dbt-sector-tc`
- In  Lake Formation - Manually register new S3 bucket as a "Data Lake location", and grant crawler role access to the Data location. Add Data lake permissions for the GLue DB, and for the GLue DB + all tables.
- Push seeds to S3:
- `dbt seed`
- Build models:
- `dbt build`
- In Lakeformation - Grant Quicksight service role access to all relevant Glue tables


# Dashboarding ideas

- Climber ages by grade of ascent (y axes boulder grade and SC grade).
- Long-lat map of ascent locations
- Top climbers of the month
- Climber profiles

