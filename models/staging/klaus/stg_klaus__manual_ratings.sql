with 

source as (

    select * from {{ source('klaus', 'manual_ratings') }}

),

renamed as (

    select
        -- ids
        payment_id,
        team_id,
        review_id,
        category_id,

        -- boolean
        critical as is_critical_rating,

        -- strings
        category_name,
        --if multiple causes can come from cause then it can be unnested and aggregated back with string_agg()
        trim(JSON_EXTRACT_ARRAY(cause)[safe_offset(0)], '"') as cause_name,

        -- numbers
        -- if rating is null or 42 the reviewer has selected to ignore it from calculations. 
        if(ifnull(rating, 42) = 42, 0, weight) as rating_weight,
        rating as rating_scale_score,
        rating_max as max_rating_scale_score,
        round(if(ifnull(rating, 42) <> 42, safe_divide(rating * 100, rating_max), null), 2) as rating_pct

    from source

)

select * from renamed
