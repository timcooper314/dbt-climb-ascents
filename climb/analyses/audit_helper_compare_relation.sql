

{% set old_etl_relation=ref('dim_climbers_old') %}

{% set dbt_relation=ref('dim_climbers') %}

{{ audit_helper.compare_relations(
    a_relation=old_etl_relation,
    b_relation=dbt_relation,
    primary_key="user_id"
)}}
