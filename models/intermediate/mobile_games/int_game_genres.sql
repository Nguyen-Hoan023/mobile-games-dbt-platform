select
    app_id,
    trim(genre_tag) as genre_tag

from {{ ref('stg_games') }},
lateral unnest(string_to_array(genres, ',')) as genre_tag

where genres is not null
  and trim(genres) <> ''
  and trim(genre_tag) <> ''