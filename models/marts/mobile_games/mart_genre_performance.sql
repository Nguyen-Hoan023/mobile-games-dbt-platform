with base as (

    select
        primary_genre,
        average_user_rating,
        user_rating_count,
        age_rating
    from {{ ref('int_games_enriched') }}

),

aggregated as (

    select
        primary_genre,

        -- Q3: genre volume
        count(*) as games,

        -- Q3: number of games with a rating
        count(average_user_rating) as games_with_rating,

        -- Q3: average rating
        cast(
            avg(average_user_rating)
            as numeric(4, 2)
        ) as avg_rating,

        -- Q3: average review count
        cast(
            avg(user_rating_count)
            as numeric(14, 2)
        ) as avg_review_count,

        -- Q7: age rating distribution
        sum(
            case
                when age_rating = '4+' then 1
                else 0
            end
        ) as age_4_plus,

        sum(
            case
                when age_rating = '9+' then 1
                else 0
            end
        ) as age_9_plus,

        sum(
            case
                when age_rating = '12+' then 1
                else 0
            end
        ) as age_12_plus,

        sum(
            case
                when age_rating = '17+' then 1
                else 0
            end
        ) as age_17_plus

    from base

    group by primary_genre

)

select
    primary_genre,
    games,
    games_with_rating,
    avg_rating,
    avg_review_count,
    age_4_plus,
    age_9_plus,
    age_12_plus,
    age_17_plus

from aggregated