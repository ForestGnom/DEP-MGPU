
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
SELECT *
FROM "superstore"."public_dw_test"."mart_customer_ltv"
WHERE average_order_value < 0

  
  
      
    ) dbt_internal_test