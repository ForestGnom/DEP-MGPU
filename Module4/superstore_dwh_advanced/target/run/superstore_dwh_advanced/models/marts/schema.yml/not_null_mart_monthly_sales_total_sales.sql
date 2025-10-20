
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_sales
from "superstore"."public_dw_test"."mart_monthly_sales"
where total_sales is null



  
  
      
    ) dbt_internal_test