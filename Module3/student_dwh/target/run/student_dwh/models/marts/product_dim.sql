
  create view "superstore"."dw_student"."product_dim__dbt_tmp"
    
    
  as (
    -- Создает справочник продуктов
SELECT
    100 + row_number() OVER (ORDER BY "product_id") as prod_id,
    "product_id",
    "product_name",
    "category",
    "sub_category",
    "segment"
FROM (
    SELECT DISTINCT "product_id", "product_name", "category", "sub_category", "segment" FROM "superstore"."dw_student"."stg_orders"
) as unique_products
  );