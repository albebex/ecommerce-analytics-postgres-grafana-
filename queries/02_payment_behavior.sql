WITH total_orders AS (
    SELECT COUNT(DISTINCT order_id) AS cnt
    FROM order_payments
)
SELECT
    payment_type,
    COUNT(*) AS payments_cnt,
    ROUND(AVG(payment_installments), 2) AS avg_installments,
    ROUND(AVG(payment_value), 2) AS avg_value,
    ROUND(
        COUNT(DISTINCT op.order_id)::numeric
        / (SELECT cnt FROM total_orders) * 100, 2
    ) AS share_pct
FROM order_payments op
GROUP BY payment_type
ORDER BY payments_cnt DESC;

