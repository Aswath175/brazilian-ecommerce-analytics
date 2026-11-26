-- Verify the customers table
DESCRIBE customers;

-- Verify the import of customer data
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT *
FROM customers
LIMIT 5;

-- Confirm the total row count
SELECT COUNT(*) AS total_customers
FROM customers;

-- Verify the import of grolocation 
SELECT COUNT(*) AS total_geolocation_rows
FROM geolocation;

-- Verify the import of order payments
SELECT COUNT(*) AS total_payment_records
FROM order_payments;

-- Verify the import of order reviews
TRUNCATE TABLE order_reviews;

SELECT COUNT(*) AS total_reviews
FROM order_reviews;

-- Verify the import of order items
SELECT COUNT(*) AS total_order_items
FROM order_items;

--
SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- verifying the table has created 
SHOW TABLES LIKE 'orders';

-- verifying the order table is imported 
SELECT COUNT(*) AS total_orders
FROM orders;

-- verifying imported products table
SELECT COUNT(*) AS total_products
FROM products;

TRUNCATE TABLE products;

-- verifying imported sellers table
SELECT COUNT(*) AS total_sellers
FROM sellers;

-- verifying imported product category translation table
SELECT COUNT(*) AS total_PCT
FROM product_category_translation;

-- final verification of all nine table
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;