with base as (

    select
        primary_genre,
        language_count

    from {{ ref('int_games_enriched') }}

    where language_count is not null

)

select
    primary_genre,

    count(*) as games,

    cast(
        avg(language_count)
        as numeric(8, 2)
    ) as avg_language_count,

    max(language_count) as max_language_count

from base

group by primary_genre