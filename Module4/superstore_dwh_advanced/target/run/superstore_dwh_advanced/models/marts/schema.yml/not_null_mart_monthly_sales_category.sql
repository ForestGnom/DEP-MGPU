
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category
from "superstore"."public_dw_test"."mart_monthly_sales"
where category is null



  
  
      
    ) dbt_internal_test