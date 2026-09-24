with genre_performance as (

    select
        ig.genre_tag,
        count(*) as games,
        cast(
            avg(g.average_user_rating)
            as numeric(4, 2)
        ) as avg_rating

    from {{ ref('int_game_genres') }} as ig

    left join {{ ref('int_games_enriched') }} as g
        on ig.app_id = g.app_id

    group by
        ig.genre_tag

),

ranked as (

    select
        genre_tag,
        games,
        avg_rating,
        row_number() over (
            order by games desc, genre_tag
        ) as genre_rank

    from genre_performance

)

select
    genre_tag,
    games,
    avg_rating,
    genre_rank

from ranked

where genre_rank <= 15