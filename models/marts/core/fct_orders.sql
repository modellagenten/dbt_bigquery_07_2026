select distinct
    o.order_id,
    o.user_id,
    o.status,
    o.ordered_at,
    o.shipped_at,
    o.delivered_at,
    o.returned_at,
    count(*) over (partition by oi.order_id) as n_items,
    sum(sale_price) over (partition by oi.order_id) as revenue,
    sum(oi.sale_price - p.cost) over (partition by oi.order_id) as profit,
    timestamp_diff(o.delivered_at, o.ordered_at, day) as days_to_delivery
from {{ ref("stg_orders") }} o
join {{ ref("stg_order_items") }} oi on o.order_id = oi.order_id
join {{ ref("stg_products") }} p on oi.product_id = p.product_id
-- where oi.order_id = 14
order by 1
