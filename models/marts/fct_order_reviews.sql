select
    r.review_id,
    r.order_id,
    o.customer_id,
    r.review_score,
    r.reviewed_at,
    case
        when r.review_score >= 4 
        then true
        else false 
    end as is_positive_review
from {{ ref('stg_order_reviews') }} r
left join {{ ref('fct_orders') }} o 
using (order_id)