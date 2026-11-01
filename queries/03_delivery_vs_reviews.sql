WITH review_per_order AS (
    SELECT order_id, AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
),
delivery_data AS (
    SELECT
        o.order_id,
        r.review_score,
        EXTRACT(DAY FROM (
        o.order_delivered_customer_date -o.order_purchase_timestamp
        )) AS delivery_days
    FROM orders o
    JOIN review_per_order r ON r.order_id = o.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL AND o.order_purchase_timestamp IS NOT NULL
)
SELECT
    CASE
        WHEN delivery_days <= 5 THEN '1. До 5 дней'
        WHEN delivery_days <= 10 THEN '2. 6-10 дней'
        ELSE '3. Более 10 дней'
    END AS bucket,
    COUNT(*) AS orders_cnt,
    ROUND(AVG(review_score), 2) AS avg_review,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS share_pct -- доля группы
FROM delivery_data
GROUP BY bucket
ORDER BY bucket;

