
  create view "superstore"."dw_student"."customer_dim__dbt_tmp"
    
    
  as (
    -- Создает справочник клиентов
SELECT
    100 + row_number() OVER (ORDER BY "customer_id") as cust_id,
    "customer_id",
    "customer_name"
FROM (
    SELECT DISTINCT "customer_id", "customer_name" FROM "superstore"."dw_student"."stg_orders"
) as unique_customers
  );