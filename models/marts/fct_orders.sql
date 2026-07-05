select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.ordered_at,
    o.delivered_at,
    count(oi.order_item_id) as item_count,
    sum(oi.price) as order_value,
    sum(oi.freight_value) as freight_total
from {{ ref('stg_orders') }} o
left join {{ ref('stg_order_items') }} oi using (order_id)
group by 1, 2, 3, 4, 5