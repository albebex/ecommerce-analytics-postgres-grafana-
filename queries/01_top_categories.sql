SELECT
    p.product_category_name AS category_pt,
    t.product_category_name_english AS category_en,
    SUM(oi.price) AS gmv,
    COUNT(DISTINCT oi.order_id) AS orders_cnt,
    COUNT(*) AS items_cnt
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation t
       ON t.product_category_name = p.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY gmv DESC
LIMIT 10;

