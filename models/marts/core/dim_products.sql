with
    products as (select * from {{ ref("stg_products") }}),

    order_items as (select * from {{ ref("stg_order_items") }}),

    sales_stats as (

        select
            product_id,
            count(*) as lifetime_units_sold,
            sum(sale_price) as lifetime_revenue,
            min(ordered_at) as first_sold_at,
            max(ordered_at) as last_sold_at
        from order_items
        group by product_id

    )

select
    p.product_id,
    p.product_name,
    p.brand,
    p.category,
    p.department,
    p.retail_price,
    p.cost,
    p.margin,

    coalesce(s.lifetime_units_sold, 0) as lifetime_units_sold,
    coalesce(s.lifetime_revenue, 0) as lifetime_revenue,
    s.first_sold_at,
    s.last_sold_at

from products p
left join sales_stats s on p.product_id = s.product_id
