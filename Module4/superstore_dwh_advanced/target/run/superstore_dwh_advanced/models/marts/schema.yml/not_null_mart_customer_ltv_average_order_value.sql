
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select average_order_value
from "superstore"."public_dw_test"."mart_customer_ltv"
where average_order_value is null



  
  
      
    ) dbt_internal_test