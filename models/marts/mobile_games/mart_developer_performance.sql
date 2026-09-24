with base as (

    select
        app_id,
        developer,
        average_user_rating,
        user_rating_count

    from {{ ref('int_games_enriched') }}

),

-- Q2: Overall developer performance
q2_aggregated as (

    select
        developer,
        count(*) as games,
        cast(
            avg(average_user_rating)
            as numeric(4, 2)
        ) as avg_rating,
        sum(user_rating_count) as total_reviews

    from base

    where developer is not null

    group by developer

),

q2_ranked as (

    select
        developer,
        games,
        avg_rating,
        total_reviews,

        row_number() over (
            order by
                games desc,
                developer
        ) as q2_rank

    from q2_aggregated

),

-- Q13: Developer rating consistency
q13_filtered as (

    select
        developer,
        average_user_rating

    from base

    where average_user_rating is not null
      and user_rating_count >= 100

),

q13_aggregated as (

    select
        developer,
        count(*) as q13_games,

        cast(
            avg(average_user_rating)
            as numeric(4, 2)
        ) as q13_avg_rating,

        cast(
            min(average_user_rating)
            as numeric(4, 2)
        ) as q13_min_rating,

        cast(
            max(average_user_rating)
            as numeric(4, 2)
        ) as q13_max_rating,

        cast(
            stddev_samp(average_user_rating)
            as numeric(6, 3)
        ) as q13_rating_stdev

    from q13_filtered

    group by developer

    having count(*) >= 5

),

q13_ranked as (

    select
        developer,
        q13_games,
        q13_avg_rating,
        q13_min_rating,
        q13_max_rating,
        q13_rating_stdev,

        row_number() over (
            order by
                q13_rating_stdev asc,
                q13_avg_rating desc,
                developer
        ) as q13_rank

    from q13_aggregated

)

select
    q2.developer,

    -- Q2
    q2.games,
    q2.avg_rating,
    q2.total_reviews,
    q2.q2_rank,

    case
        when q2.q2_rank <= 10 then true
        else false
    end as q2_eligible,

    -- Q13
    q13.q13_games,
    q13.q13_avg_rating,
    q13.q13_min_rating,
    q13.q13_max_rating,
    q13.q13_rating_stdev,
    q13.q13_rank,

    case
        when q13.q13_rank is not null then true
        else false
    end as q13_eligible

from q2_ranked as q2

left join q13_ranked as q13
    on q2.developer = q13.developer