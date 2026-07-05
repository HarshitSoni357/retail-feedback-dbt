select
    p.product_id,
    coalesce(t.product_category_name_english, p.product_category_name) as product_category
from {{ source('raw', 'olist_products_dataset') }} p
left join {{ source('raw', 'product_category_name_translation') }} t
    on p.product_category_name = t.product_category_name