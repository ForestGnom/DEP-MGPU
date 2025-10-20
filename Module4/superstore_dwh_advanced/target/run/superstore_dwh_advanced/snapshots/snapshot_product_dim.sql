
      
  
    

  create  table "superstore"."dw_snapshots"."snapshot_product_dim"
  
  
    as
  
  (
    
    

    select *,
        md5(coalesce(cast(prod_id as varchar ), '')
         || '|' || coalesce(cast(now()::timestamp without time zone as varchar ), '')
        ) as dbt_scd_id,
        now()::timestamp without time zone as dbt_updated_at,
        now()::timestamp without time zone as dbt_valid_from,
        
  
  coalesce(nullif(now()::timestamp without time zone, now()::timestamp without time zone), null)
  as dbt_valid_to
from (
        

SELECT prod_id, product_id, segment, category FROM "superstore"."dw_test"."product_dim"
    ) sbq



  );
  
  