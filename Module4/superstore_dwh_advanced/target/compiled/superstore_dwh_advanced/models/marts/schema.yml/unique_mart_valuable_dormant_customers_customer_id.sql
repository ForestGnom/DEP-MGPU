
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
where customer_id is not null
group by customer_id
having count(*) > 1


