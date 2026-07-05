select
    order_id,
    customer_id,
    order_status,
    cast(order_purchase_timestamp as timestamp) as ordered_at,
    cast(order_delivered_customer_date as timestamp) as delivered_at
from {{ source('raw', 'olist_orders_dataset') }}