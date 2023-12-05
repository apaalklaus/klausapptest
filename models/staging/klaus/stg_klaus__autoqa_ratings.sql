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
        reviewee_internal_id,

        -- strings
        rating_category_name,

        -- numbers
        score,
        rating_scale_score

    from source

)

select * from renamed
