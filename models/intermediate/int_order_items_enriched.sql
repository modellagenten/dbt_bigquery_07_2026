-- models/intermediate/int_order_items_enriched.sql
{{ config(materialized="ephemeral") }}
with
    items as (
        select order_item_id, order_id, user_id, product_id, sale_price
        from {{ ref("stg_order_items") }}
    ),
    products as (
        select product_id, product_name, category, brand, cost
        from {{ ref("stg_products") }}
    )
select
    i.order_item_id,
    i.order_id,
    i.user_id,
    i.product_id,
    i.sale_price,
    p.product_name,
    p.category,
    p.brand,
    p.cost,
    i.sale_price - p.cost as profit
from items i
right join products p on i.product_id = p.product_id
