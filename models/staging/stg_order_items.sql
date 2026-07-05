select
    order_id,
    order_item_id,
    product_id,
    cast(price as decimal(10,2)) as price,
    cast(freight_value as decimal(10,2)) as freight_value
from {{ source('raw', 'olist_order_items_dataset') }}