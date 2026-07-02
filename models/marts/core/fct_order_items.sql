-- models/marts/core/fct_order_items.sql
{{ config(materialized="table") }} 
select * from {{ ref("int_order_items_enriched") }}
