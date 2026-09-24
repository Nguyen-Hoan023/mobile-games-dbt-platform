select
    -- Key
    app_id,

    -- Core game attributes
    name,
    developer,
    primary_genre,
    genres,
    age_rating,

    -- Release
    release_date,
    extract(year from release_date)::integer as release_year,

    -- Pricing
    price_usd,
    case
        when price_usd = 0 then true
        when price_usd > 0 then false
        else null
    end as is_free,

    -- Rating / popularity
    average_user_rating,
    user_rating_count,
    case
        when average_user_rating is not null
         and user_rating_count is not null
        then true
        else false
    end as is_rated,

    -- Game size
    size_in_bytes,
    size_mb,

    -- Localization
    languages,
    case
        when languages is null
          or trim(languages) = ''
        then null
        else length(languages)
             - length(replace(languages, ',', ''))
             + 1
    end as language_count,

    -- Content analysis
    description

from {{ ref('stg_games') }}