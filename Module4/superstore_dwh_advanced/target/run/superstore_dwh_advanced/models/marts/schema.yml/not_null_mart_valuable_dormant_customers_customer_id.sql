
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_id
from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
where customer_id is null



  
  
      
    ) dbt_internal_test