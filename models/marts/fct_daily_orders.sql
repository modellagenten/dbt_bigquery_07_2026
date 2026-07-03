{{
    config(
        materialized="incremental",
        unique_key="order_day",
        incremental_strategy="merge",
        on_schema_change="sync_all_columns",
    )
}}
with
    orders as (
        select *
        from {{ ref("stg_orders") }}
        {% if is_incremental() %}
            where
                date(ordered_at)
                >= date_sub((select max(order_day) from {{ this }}), interval 3 day)
        {% endif %}
    ),
    aggregated as (
        select
            date(ordered_at) as order_day,
            count(*) as n_orders,
            countif(status = 'Complete') as n_complete,
            countif(status = 'Cancelled') as n_cancelled,
            countif(status = 'Returned') as n_returned,
            sum(num_of_item) as n_items,
            current_timestamp() as loaded_at
        from orders
        group by order_day
    )
select *
from aggregated
