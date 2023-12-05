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
        weight as rating_weight,
        rating,
        rating_max

    from source

)

select * from renamed
