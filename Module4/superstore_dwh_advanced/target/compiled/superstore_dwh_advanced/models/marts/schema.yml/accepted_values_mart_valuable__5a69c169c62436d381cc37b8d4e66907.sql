
    
    

with all_values as (

    select
        customer_status as value_field,
        count(*) as n_records

    from "superstore"."public_dw_test"."mart_valuable_dormant_customers"
    group by customer_status

)

select *
from all_values
where value_field not in (
    'DORMANT_VALUABLE'
)


