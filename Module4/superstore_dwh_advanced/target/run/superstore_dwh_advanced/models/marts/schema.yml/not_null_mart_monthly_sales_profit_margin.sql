
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select profit_margin
from "superstore"."public_dw_test"."mart_monthly_sales"
where profit_margin is null



  
  
      
    ) dbt_internal_test