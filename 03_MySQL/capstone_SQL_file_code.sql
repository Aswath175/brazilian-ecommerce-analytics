CREATE DATABASE IF NOT EXISTS olist_capstone;
USE olist_capstone;
SELECT DATABASE();


-- Creating the customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- Creating the geolocation table
CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix VARCHAR(5),
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

-- Creating the order items table
CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- Creating the order payments table
CREATE TABLE IF NOT EXISTS order_payments (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- Creating the order reviews table
CREATE TABLE order_reviews (
    review_record_id INT AUTO_INCREMENT PRIMARY KEY,
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- importing the order reviews dataset
LOAD DATA LOCAL INFILE
'D:/capstone project file/cleaned data/olist_order_reviews_cleaned.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
);

-- creating the orders table 
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME
);

-- importing orders table 
LOAD DATA LOCAL INFILE
'D:/capstone project file/cleaned data/olist_orders_cleaned.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    @approved_at,
    @carrier_date,
    @delivered_date,
    order_estimated_delivery_date
)
SET
    order_approved_at =
        NULLIF(@approved_at, ''),
    order_delivered_carrier_date =
        NULLIF(@carrier_date, ''),
    order_delivered_customer_date =
        NULLIF(@delivered_date, '');

-- creating the products table
CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT NULL,
    product_description_lenght INT NULL,
    product_photos_qty INT NULL,
    product_weight_g DOUBLE NULL,
    product_length_cm DOUBLE NULL,
    product_height_cm DOUBLE NULL,
    product_width_cm DOUBLE NULL,
    product_details_missing BOOLEAN,
    product_dimensions_missing BOOLEAN
);

-- importing products dataset into products table
LOAD DATA LOCAL INFILE
'D:/capstone project file/cleaned data/olist_products_cleaned.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    product_id,
    product_category_name,
    @name_length,
    @description_length,
    @photos_qty,
    @weight,
    @length,
    @height,
    @width,
    @details_missing,
    @dimensions_missing
)
SET
    product_name_lenght = NULLIF(@name_length, ''),
    product_description_lenght = NULLIF(@description_length, ''),
    product_photos_qty = NULLIF(@photos_qty, ''),
    product_weight_g = NULLIF(@weight, ''),
    product_length_cm = NULLIF(@length, ''),
    product_height_cm = NULLIF(@height, ''),
    product_width_cm = NULLIF(@width, ''),
    product_details_missing =
        IF(LOWER(@details_missing) = 'true', 1, 0),
    product_dimensions_missing =
        IF(LOWER(@dimensions_missing) = 'true', 1, 0);

-- creating sellers table
CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- importing sellers dataset
LOAD DATA LOCAL INFILE
'D:/capstone project file/cleaned data/olist_sellers_cleaned.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);

-- creating product category translation table
CREATE TABLE IF NOT EXISTS product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- importing product category translation dataset
LOAD DATA LOCAL INFILE
'D:/capstone project file/cleaned data/product_category_translation_cleaned.csv'
INTO TABLE product_category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    product_category_name,
    product_category_name_english
);

