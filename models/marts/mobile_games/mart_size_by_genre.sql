with base as (

    select
        primary_genre,
        size_in_bytes

    from {{ ref('int_games_enriched') }}

    where size_in_bytes is not null

)

select
    primary_genre,

    count(*) as games,

    cast(
        avg(size_in_bytes::numeric) / 1048576
        as numeric(12, 2)
    ) as avg_size_mb,

    cast(
        max(size_in_bytes::numeric) / 1048576
        as numeric(12, 2)
    ) as max_size_mb

from base

group by primary_genre