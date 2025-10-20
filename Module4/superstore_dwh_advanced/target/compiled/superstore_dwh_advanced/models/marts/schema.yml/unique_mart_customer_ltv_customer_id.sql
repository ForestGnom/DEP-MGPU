
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "superstore"."public_dw_test"."mart_customer_ltv"
where customer_id is not null
group by customer_id
having count(*) > 1


