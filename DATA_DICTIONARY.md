# DATA_DICTIONARY.md

## olist_customers_dataset
- customer_id (string) — unique id per order (changes even for repeat customers)
- customer_unique_id (string) — stable id across a customer's multiple orders
- customer_city, customer_state (string)

## olist_orders_dataset
- order_id (string) — primary key
- customer_id (string) — FK to customers
- order_status (string) — delivered, shipped, canceled, invoiced, processing, unavailable, created, approved
- order_purchase_timestamp, order_delivered_customer_date (timestamp)

## olist_order_items_dataset
- order_id (string) — FK to orders (one order can have multiple items)
- order_item_id (int) — sequence number within the order
- product_id (string) — FK to products
- price (decimal) — item price
- freight_value (decimal) — shipping cost for that item

## olist_order_reviews_dataset
- review_id (string) — primary key
- order_id (string) — FK to orders
- review_score (int, 1–5) — star rating given by customer
- review_comment_title, review_comment_message (string, nullable) — free-text feedback
- review_creation_date (timestamp)

## olist_products_dataset
- product_id (string) — primary key
- product_category_name (string, Portuguese) — join to translation table for English name

## product_category_name_translation
- product_category_name (string, Portuguese)
- product_category_name_english (string)