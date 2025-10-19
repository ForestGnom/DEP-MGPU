--"Хвост продаж". Процент от общей выручки, который приносят 20% самых прибыльных клиентов (Анализ Парето)
SELECT 
    ROUND(
        (SELECT SUM(sales) 
         FROM "superstore"."dw_student"."sales_fact" 
         WHERE cust_id IN (
             SELECT cust_id 
             FROM (
                 SELECT 
                     cust_id,
                     SUM(profit) as total_profit
                 FROM "superstore"."dw_student"."sales_fact" 
                 GROUP BY cust_id
                 ORDER BY total_profit DESC
                 LIMIT (SELECT CEIL(COUNT(DISTINCT cust_id) * 0.2) FROM "superstore"."dw_student"."sales_fact")
             ) as top_customers
         )) * 100.0 / 
        (SELECT SUM(sales) FROM "superstore"."dw_student"."sales_fact"),
    2) as percent_sales_from_top_20_percent_customers