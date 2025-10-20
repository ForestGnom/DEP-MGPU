
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select days_since_last_order
from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
where days_since_last_order is null



  
  
      
    ) dbt_internal_test