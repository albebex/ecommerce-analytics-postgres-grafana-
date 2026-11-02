-- Ограничение: customer_id создаётся на каждый заказ, поэтому customers_cnt равен числу заказов; для клиентов нужен customer_unique_id

SELECT
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS orders_cnt,
    COUNT(DISTINCT c.customer_unique_id) AS customers_cnt,
    COUNT(*) AS items_cnt,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight
FROM order_items oi
JOIN sellers s ON s.seller_id = oi.seller_id
JOIN orders o ON o.order_id = oi.order_id
GROUP BY s.seller_id
ORDER BY orders_cnt DESC
LIMIT 10;
 

