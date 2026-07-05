select
    review_id,
    order_id,
    cast(review_score as integer) as review_score,
    review_comment_title,
    review_comment_message,
    cast(review_creation_date as timestamp) as reviewed_at
from {{ source('raw', 'olist_order_reviews_dataset') }}