
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select segment
from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
where segment is null



  
  
      
    ) dbt_internal_test