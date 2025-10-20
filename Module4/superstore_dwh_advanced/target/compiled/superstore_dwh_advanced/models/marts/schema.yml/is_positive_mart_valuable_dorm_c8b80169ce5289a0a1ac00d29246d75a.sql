
SELECT *
FROM "superstore"."public_dw_test"."mart_valuable_dormant_customers"
WHERE days_since_last_order < 0
