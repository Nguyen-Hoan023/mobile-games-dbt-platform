with base as (

    select
        size_in_bytes,
        average_user_rating,
        user_rating_count

    from {{ ref('int_games_enriched') }}

    where size_in_bytes is not null
      and average_user_rating is not null

),

classified as (

    select
        average_user_rating,
        user_rating_count,

        case
            when size_in_bytes < 52428800
                then '1. Nhỏ (<50MB)'

            when size_in_bytes < 209715200
                then '2. Vừa (50-200MB)'

            else '3. Lớn (>200MB)'
        end as size_band,

        case
            when size_in_bytes < 52428800 then 1
            when size_in_bytes < 209715200 then 2
            else 3
        end as size_band_order

    from base

)

select
    size_band,
    size_band_order,
    count(*) as games,

    cast(
        avg(average_user_rating)
        as numeric(4, 2)
    ) as avg_rating,

    cast(
        avg(user_rating_count::numeric)
        as numeric(14, 2)
    ) as avg_review_count

from classified

group by
    size_band,
    size_band_order

order by size_band_order