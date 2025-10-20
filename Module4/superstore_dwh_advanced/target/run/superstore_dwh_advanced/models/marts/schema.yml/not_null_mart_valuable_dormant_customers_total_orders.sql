
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_orders
from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
where total_orders is null



  
  
      
    ) dbt_internal_test