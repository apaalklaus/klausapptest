with 

source as (

    select * from {{ source('klaus', 'autoqa_reviews') }}

),

renamed as (

    select
        -- ids
        autoqa_review_id,
        payment_id,
        payment_token_id,
        external_ticket_id,     
        reviewee_internal_id,
        team_id,
    
        --dates
        cast(conversation_created_date as date) as conversation_created_date,   

        -- timestamps
        cast(created_at as timestamp) as created_at,
        cast(updated_at as timestamp) as updated_at

    from source

)

select * from renamed
