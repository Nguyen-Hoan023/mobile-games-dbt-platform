with base as (

    select
        app_id,
        name,
        developer,
        primary_genre,
        average_user_rating,
        user_rating_count,
        price_usd

    from {{ ref('int_games_enriched') }}

),

q6_ranked as (

    select
        app_id,

        row_number() over (
            order by
                average_user_rating desc,
                user_rating_count desc,
                name
        ) as q6_rank

    from base

    where user_rating_count > 10000
      and average_user_rating is not null

),

q11_ranked as (

    select
        app_id,

        row_number() over (
            partition by primary_genre
            order by
                average_user_rating desc,
                user_rating_count desc,
                name
        ) as q11_rank

    from base

    where user_rating_count >= 1000
      and average_user_rating is not null

),

final as (

    select
        b.app_id,
        b.name,
        b.developer,
        b.primary_genre,
        b.average_user_rating,
        b.user_rating_count,
        b.price_usd,

        case
            when b.user_rating_count > 10000
             and b.average_user_rating is not null
            then true
            else false
        end as q6_eligible,

        q6.q6_rank,

        case
            when b.user_rating_count >= 1000
             and b.average_user_rating is not null
            then true
            else false
        end as q11_eligible,

        q11.q11_rank

    from base as b

    left join q6_ranked as q6
        on b.app_id = q6.app_id

    left join q11_ranked as q11
        on b.app_id = q11.app_id

)

select *
from final