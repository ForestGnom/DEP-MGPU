
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
SELECT *
FROM "superstore"."public_dw_test"."mart_valuable_dormant_customers"
WHERE total_orders < 0

  
  
      
    ) dbt_internal_test