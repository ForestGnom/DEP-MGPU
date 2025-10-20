
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_sales_lifetime
from "superstore"."public_dw_test"."mart_customer_ltv"
where total_sales_lifetime is null



  
  
      
    ) dbt_internal_test