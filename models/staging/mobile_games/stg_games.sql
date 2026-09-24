select
    cast(app_id as bigint) as app_id,

    nullif(trim(app_url), '') as app_url,
    nullif(trim(name), '') as name,
    nullif(trim(subtitle), '') as subtitle,
    nullif(trim(icon_url), '') as icon_url,

    cast(average_user_rating as numeric(3,2)) as average_user_rating,
    cast(user_rating_count as integer) as user_rating_count,
    cast(price_usd as numeric(10,2)) as price_usd,

    nullif(trim(description), '') as description,
    nullif(trim(developer), '') as developer,
    nullif(trim(age_rating), '') as age_rating,
    nullif(trim(languages), '') as languages,

    cast(size_in_bytes as bigint) as size_in_bytes,
    round(size_in_bytes / 1048576.0, 2) as size_mb,

    nullif(trim(primary_genre), '') as primary_genre,
    nullif(trim(genres), '') as genres,

    cast(release_date as date) as release_date

from {{ source('mobile_games', 'games') }}

where coalesce(_fivetran_deleted, false) = false