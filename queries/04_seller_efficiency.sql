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
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY s.seller_id
ORDER BY orders_cnt DESC
LIMIT 10;
 
-- Проверка гипотезы: есть ли повторные покупатели?
SELECT
    COUNT(*) AS customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;
-- Если unique_customers меньше customer_ids, повторные покупки есть
 
-- Доля покупателей с более чем одним заказом
SELECT 
    ROUND(100.0 * COUNT(*) FILTER (WHERE orders_cnt > 1) / COUNT(*), 2) AS repeat_customers_pct
FROM (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS orders_cnt
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t;

