with base as (
    select
        primary_genre,
        description
    from {{ ref('int_games_enriched') }}
    where primary_genre is not null
)

select
    primary_genre,

    count(*) as total_games,

    sum(
        case
            when description ilike '%puzzle%' then 1
            else 0
        end
    ) as mentions_puzzle,

    sum(
        case
            when description ilike '%multiplayer%' then 1
            else 0
        end
    ) as mentions_multiplayer,

    sum(
        case
            when description ilike '%puzzle%'
              or description ilike '%multiplayer%'
            then 1
            else 0
        end
    ) as mentions_either

from base
group by primary_genre