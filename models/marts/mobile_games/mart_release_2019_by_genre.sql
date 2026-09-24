with base as (

    select
        primary_genre,
        average_user_rating,
        release_date

    from {{ ref('int_games_enriched') }}

    where release_date >= date '2019-01-01'
      and release_date < date '2020-01-01'

)

select
    primary_genre,
    count(*) as games_released,
    cast(
        avg(average_user_rating)
        as numeric(4, 2)
    ) as avg_rating

from base

group by primary_genre