with base as (

    select
        price_usd,
        average_user_rating
    from {{ ref('int_games_enriched') }}

),

classified as (

    select
        price_usd,
        average_user_rating,

        case
            when price_usd = 0 then 'Free'
            else 'Paid'
        end as pricing_model,

        case
            when price_usd = 0 then '1. Free'
            when price_usd < 1 then '2. Dưới 1 USD'
            when price_usd < 5 then '3. 1-4.99 USD'
            when price_usd < 20 then '4. 5-19.99 USD'
            else '5. Từ 20 USD'
        end as price_band,

        case
            when price_usd = 0 then 1
            when price_usd < 1 then 2
            when price_usd < 5 then 3
            when price_usd < 20 then 4
            else 5
        end as price_band_order

    from base

),

aggregated as (

    select
        price_band,
        pricing_model,
        price_band_order,
        count(*) as games,
        cast(
            100.0 * count(*) / sum(count(*)) over ()
            as numeric(5, 2)
        ) as pct_of_total,
        cast(
            avg(average_user_rating)
            as numeric(4, 2)
        ) as avg_rating

    from classified

    group by
        price_band,
        pricing_model,
        price_band_order

)

select
    price_band,
    pricing_model,
    price_band_order,
    games,
    pct_of_total,
    avg_rating

from aggregated

order by price_band_order