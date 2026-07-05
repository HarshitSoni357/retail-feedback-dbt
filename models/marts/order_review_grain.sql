select
    o.order_id,
    o.customer_id,
    r.review_score,
    r.is_positive_review
from {{ ref('fct_orders') }} o
left join {{ ref('fct_order_reviews') }} r on o.order_id = r.order_id