-- 1) Overall sales performance
-- BQ: How much revenue has the e-commerce platform generated, how many orders were placed, and how many customers purchased?

USE olist_capstone;

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(SUM(oi.price), 2) AS total_product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
    
-- 2) Monthly sales performance
-- BQ: How does the platform's sales performance change from month to month?

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS monthly_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;
    
-- 3) Top 10 product categories by revenue
-- BQ:  Which product categories generate the highest revenue?

SELECT
    COALESCE(
        pct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY
    COALESCE(
        pct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    )
ORDER BY total_revenue DESC
LIMIT 10;

-- 4) Top 10 sellers by revenue
-- BQ: Which sellers generate the highest product revenue on the platform?

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;
    
    
-- 5) Order status analysis
-- BQ: What is the distribution of orders across different statuses, such as delivered, shipped, canceled, and unavailable?
    
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage
FROM orders
GROUP BY order_status 
ORDER BY total_orders DESC;

-- 6) Delivery performance analysis
-- BQ: How long does Olist take to deliver orders, on average, and how often does it deliver before or after the estimated date?

SELECT
    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS avg_delivery_days,

    ROUND(
        AVG(
            DATEDIFF(
                order_estimated_delivery_date,
                order_delivered_customer_date
            )
        ), 2
    ) AS avg_days_before_estimated_date,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 <= order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delivered_on_or_before_estimate,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delivered_late

FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- 7) Customer review analysis
-- BQ: How satisfied are customers with their shopping experience on Olist?

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_reviews),
        2
    ) AS review_percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- 8) Average order value (AOV)
-- BQ: How much does a customer spend on average per order?

SELECT
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value,

    ROUND(
        SUM(price),
        2
    ) AS total_product_revenue,

    ROUND(
        SUM(freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_freight_per_order

FROM order_items;