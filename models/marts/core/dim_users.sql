with users as (
 
    select
        user_id,
        first_name,
        last_name,
        email,
        country,
        city,
        traffic_source,
        registered_at
    from {{ ref('stg_users') }}
 
),
 
completed_orders as (
 
    select
        user_id,
        count(*) as lifetime_orders,
        sum(num_of_item) as lifetime_items,
        min(ordered_at) as first_order_at,
        max(ordered_at) as last_order_at
    from {{ ref('stg_orders') }}
    where status = 'Complete'
    group by user_id
 
)
 
select
    users.user_id,
    users.first_name,
    users.last_name,
    users.email,
    users.country,
    users.city,
    users.traffic_source,
    users.registered_at,
 
    count(coalesce(completed_orders.lifetime_orders, 0)) as lifetime_orders,
    sum(coalesce(completed_orders.lifetime_items, 0)) as lifetime_items,
    min(completed_orders.first_order_at) as first_order_at,
    max(completed_orders.last_order_at) as last_order_at
 
from users
left join completed_orders
    on users.user_id = completed_orders.user_id
group by users.user_id,
         users.first_name,
         users.last_name,
         users.email,
         users.country,
         users.city,
         users.traffic_source,
         users.registered_at    