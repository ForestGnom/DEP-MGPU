
  create view "superstore"."dw_student"."geo_dim__dbt_tmp"
    
    
  as (
    -- Создает географический справочник
SELECT
    100 + row_number() OVER (ORDER BY "postal_code", "city", "state") as geo_id,
    "country",
    "city",
    "state",
    "postal_code"
FROM (
    SELECT DISTINCT "country", "city", "state", "postal_code" FROM "superstore"."dw_student"."stg_orders"
) as unique_geo
  );