# Climbs
A sample project using dbt on postgres for Climbing data.


# DB
Spin up the Postgres database using the spin_up_postgres.sh script.

To load seed data into tables:
`dbt seed`



To create lineage diagram:
`dbt docs generate`
`dbt docs serve`


# Project ideas
- Seeds in S3


# Dashboarding ideas

- Climber ages by grade of ascent (y axes boulder grade and SC grade).
- Long-lat map of ascent locations
- Top climbers of the month
- Climber profiles

