
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select first_order_date
from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
where first_order_date is null



  
  
      
    ) dbt_internal_test