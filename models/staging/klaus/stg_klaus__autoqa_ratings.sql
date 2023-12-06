with 

source as (

    select * from {{ source('klaus', 'autoqa_ratings') }}

),

renamed as (

    select
        -- ids
        autoqa_rating_id,
        autoqa_review_id,
        payment_id,
        team_id,
        payment_token_id,
        external_ticket_id,
        rating_category_id,
        reviewee_internal_id as reviewee_user_id,

        -- strings
        lower(rating_category_name) as rating_category_name,

        -- numbers
        score as score_pct,
        rating_scale_score

    from source

)

select * from renamed order by score_pct desc
