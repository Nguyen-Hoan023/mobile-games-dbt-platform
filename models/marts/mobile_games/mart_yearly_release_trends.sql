with yearly as (

    select
        release_year,
        count(*) as games_released,
        cast(
            avg(average_user_rating)
            as numeric(4, 2)
        ) as avg_rating

    from {{ ref('int_games_enriched') }}

    where release_year is not null

    group by release_year

),

with_previous_year as (

    select
        release_year,
        games_released,
        avg_rating,

        lag(games_released) over (
            order by release_year
        ) as prev_year_games

    from yearly

)

select
    release_year,
    games_released,
    avg_rating,
    prev_year_games,

    cast(
        100.0 * (games_released - prev_year_games)
        / nullif(prev_year_games, 0)
        as numeric(8, 2)
    ) as yoy_growth_pct

from with_previous_year